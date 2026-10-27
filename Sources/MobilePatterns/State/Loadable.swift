/// The state of a value that a screen loads asynchronously: the *view state* pattern.
///
/// One enum replaces the usual trio of `isLoading`, `error` and `items` properties, so a screen
/// can never be "loading" and "failed" at the same time. A reload keeps the value that is on
/// screen in `previous`, which lets a list stay visible under a refresh indicator or an error
/// banner instead of flashing back to a spinner.
///
/// ```swift
/// var state: Loadable<[Article], APIError> = .idle
///
/// state.startLoading()                    // .loading(previous: nil)
/// state.finish(with: .success(articles))  // .loaded(articles)
/// state.startLoading()                    // .loading(previous: articles)
/// state.finish(with: .failure(.offline))  // .failed(.offline, previous: articles)
/// ```
public enum Loadable<Value, Failure: Error> {
    /// Nothing has been requested yet.
    case idle
    /// A load is running. `previous` is the value from an earlier load, if there was one.
    case loading(previous: Value?)
    /// The last load succeeded.
    case loaded(Value)
    /// The last load failed. `previous` is the value from an earlier load, if there was one.
    case failed(Failure, previous: Value?)

    /// The newest value available in any state: the loaded value, or the one kept from an
    /// earlier load while loading again or after a failure.
    public var value: Value? {
        switch self {
        case .idle: nil
        case .loading(let previous): previous
        case .loaded(let value): value
        case .failed(_, let previous): previous
        }
    }

    /// The error of the last load when it failed, otherwise `nil`.
    public var failure: Failure? {
        if case .failed(let failure, _) = self { return failure }
        return nil
    }

    /// Whether a load is running.
    public var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }

    /// Moves to ``loading(previous:)`` and keeps the current ``value``.
    ///
    /// Calling it while already loading changes nothing, so a second pull-to-refresh does not
    /// lose the kept value.
    public mutating func startLoading() {
        if isLoading { return }
        self = .loading(previous: value)
    }

    /// Moves to ``loaded(_:)`` on success, or to ``failed(_:previous:)`` with the current
    /// ``value`` kept on failure.
    public mutating func finish(with result: Result<Value, Failure>) {
        switch result {
        case .success(let value):
            self = .loaded(value)
        case .failure(let failure):
            self = .failed(failure, previous: value)
        }
    }

    /// Transforms the value in every state and keeps the state itself.
    public func map<NewValue>(_ transform: (Value) -> NewValue) -> Loadable<NewValue, Failure> {
        switch self {
        case .idle: .idle
        case .loading(let previous): .loading(previous: previous.map(transform))
        case .loaded(let value): .loaded(transform(value))
        case .failed(let failure, let previous): .failed(failure, previous: previous.map(transform))
        }
    }
}

extension Loadable: Sendable where Value: Sendable {}
extension Loadable: Equatable where Value: Equatable, Failure: Equatable {}
