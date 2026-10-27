import os

/// Calls an API that reports through a completion handler and returns its result with
/// `async`/`await`: the *adapter* pattern between callback code and Swift concurrency.
///
/// A plain `withCheckedThrowingContinuation` crashes when a third-party SDK calls its completion
/// handler twice, and hangs when the task is cancelled while the SDK never answers. This adapter
/// keeps the first result and ignores later ones, and it returns `CancellationError` as soon as
/// the task is cancelled, calling `onCancel` so the underlying request can be stopped too.
///
/// ```swift
/// let profile = try await withCompletion(onCancel: { request.cancel() }) { completion in
///     legacyClient.fetchProfile(id: id) { profile, error in
///         if let profile { completion(.success(profile)) }
///         else { completion(.failure(error ?? LegacyError.empty)) }
///     }
/// }
/// ```
///
/// - Parameters:
///   - onCancel: Called once when the task is cancelled before a result arrived.
///   - start: Starts the callback API and passes `completion` to it. It is not called when the
///     task is already cancelled.
/// - Returns: The value of the first `.success` handed to `completion`.
/// - Throws: The error of the first `.failure`, or `CancellationError`.
public func withCompletion<Value: Sendable>(
    onCancel: @escaping @Sendable () -> Void = {},
    _ start: (_ completion: @escaping @Sendable (Result<Value, any Error>) -> Void) -> Void
) async throws -> Value {
    let gate = ResumeOnce<Value>()
    return try await withTaskCancellationHandler {
        try await withCheckedThrowingContinuation { continuation in
            guard gate.install(continuation) else { return }
            start { result in gate.resume(with: result) }
        }
    } onCancel: {
        if gate.resume(with: .failure(CancellationError())) { onCancel() }
    }
}

/// Resumes a continuation exactly once, whichever of the callback and cancellation comes first.
final class ResumeOnce<Value: Sendable>: Sendable {
    private struct State {
        var continuation: CheckedContinuation<Value, any Error>?
        var early: Result<Value, any Error>?
        var isDone = false
    }

    private let state = OSAllocatedUnfairLock(initialState: State())

    /// Stores the continuation. Returns `false` when a result (cancellation) came first; the
    /// continuation is then already resumed and the work must not start.
    func install(_ continuation: CheckedContinuation<Value, any Error>) -> Bool {
        let early: Result<Value, any Error>? = state.withLock { state in
            if let early = state.early { return early }
            state.continuation = continuation
            return nil
        }
        guard let early else { return true }
        continuation.resume(with: early)
        return false
    }

    /// Delivers `result` if nothing was delivered yet. Returns whether it was the first.
    @discardableResult
    func resume(with result: Result<Value, any Error>) -> Bool {
        let continuation: CheckedContinuation<Value, any Error>?? = state.withLock { state in
            guard !state.isDone else { return .none }
            state.isDone = true
            guard let continuation = state.continuation else {
                state.early = result
                return .some(nil)
            }
            state.continuation = nil
            return .some(continuation)
        }
        guard let first = continuation else { return false }
        first?.resume(with: result)
        return true
    }
}
