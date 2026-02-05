# State Pattern

> Allow object to alter behavior when internal state changes

## Problem

- Object behavior depends on state
- State transitions have specific rules
- Large conditional statements based on state

## Solution

```swift
// MARK: - State Protocol
protocol OrderState {
    func next(order: Order) -> OrderState?
    func cancel(order: Order) -> OrderState?
    func ship(order: Order) -> OrderState?
    func deliver(order: Order) -> OrderState?
    
    var statusDescription: String { get }
    var allowedActions: [OrderAction] { get }
}

enum OrderAction {
    case confirm, cancel, ship, deliver, refund
}

// MARK: - Context
class Order {
    private(set) var state: OrderState
    let id: String
    let items: [OrderItem]
    var trackingNumber: String?
    
    init(id: String, items: [OrderItem]) {
        self.id = id
        self.items = items
        self.state = PendingState()
    }
    
    func transition(to newState: OrderState) {
        print("Order \(id): \(state.statusDescription) → \(newState.statusDescription)")
        state = newState
    }
    
    func confirm() { if let newState = state.next(order: self) { transition(to: newState) } }
    func cancel() { if let newState = state.cancel(order: self) { transition(to: newState) } }
    func ship() { if let newState = state.ship(order: self) { transition(to: newState) } }
    func deliver() { if let newState = state.deliver(order: self) { transition(to: newState) } }
}

// MARK: - Concrete States
class PendingState: OrderState {
    var statusDescription: String { "Pending Payment" }
    var allowedActions: [OrderAction] { [.confirm, .cancel] }
    
    func next(order: Order) -> OrderState? {
        return ConfirmedState()
    }
    
    func cancel(order: Order) -> OrderState? {
        return CancelledState(reason: "Customer cancelled")
    }
    
    func ship(order: Order) -> OrderState? { nil }
    func deliver(order: Order) -> OrderState? { nil }
}

class ConfirmedState: OrderState {
    var statusDescription: String { "Confirmed" }
    var allowedActions: [OrderAction] { [.ship, .cancel] }
    
    func next(order: Order) -> OrderState? { nil }
    
    func cancel(order: Order) -> OrderState? {
        return CancelledState(reason: "Cancelled after confirmation")
    }
    
    func ship(order: Order) -> OrderState? {
        guard order.trackingNumber != nil else {
            print("Cannot ship without tracking number")
            return nil
        }
        return ShippedState()
    }
    
    func deliver(order: Order) -> OrderState? { nil }
}

class ShippedState: OrderState {
    var statusDescription: String { "Shipped" }
    var allowedActions: [OrderAction] { [.deliver] }
    
    func next(order: Order) -> OrderState? { nil }
    func cancel(order: Order) -> OrderState? { nil }
    func ship(order: Order) -> OrderState? { nil }
    
    func deliver(order: Order) -> OrderState? {
        return DeliveredState()
    }
}

class DeliveredState: OrderState {
    var statusDescription: String { "Delivered" }
    var allowedActions: [OrderAction] { [.refund] }
    
    func next(order: Order) -> OrderState? { nil }
    func cancel(order: Order) -> OrderState? { nil }
    func ship(order: Order) -> OrderState? { nil }
    func deliver(order: Order) -> OrderState? { nil }
}

class CancelledState: OrderState {
    let reason: String
    var statusDescription: String { "Cancelled: \(reason)" }
    var allowedActions: [OrderAction] { [] }
    
    init(reason: String) {
        self.reason = reason
    }
    
    func next(order: Order) -> OrderState? { nil }
    func cancel(order: Order) -> OrderState? { nil }
    func ship(order: Order) -> OrderState? { nil }
    func deliver(order: Order) -> OrderState? { nil }
}

// MARK: - Usage
let order = Order(id: "ORD-001", items: [OrderItem(name: "iPhone", quantity: 1)])

order.confirm() // Pending → Confirmed
order.trackingNumber = "1Z999AA10123456784"
order.ship() // Confirmed → Shipped
order.deliver() // Shipped → Delivered
order.cancel() // No effect - delivered orders can't be cancelled
```

## Media Player State Machine

```swift
protocol PlayerState {
    func play(player: MediaPlayer) -> PlayerState
    func pause(player: MediaPlayer) -> PlayerState
    func stop(player: MediaPlayer) -> PlayerState
}

class StoppedState: PlayerState {
    func play(player: MediaPlayer) -> PlayerState {
        player.startPlayback()
        return PlayingState()
    }
    
    func pause(player: MediaPlayer) -> PlayerState { self }
    func stop(player: MediaPlayer) -> PlayerState { self }
}

class PlayingState: PlayerState {
    func play(player: MediaPlayer) -> PlayerState { self }
    
    func pause(player: MediaPlayer) -> PlayerState {
        player.pausePlayback()
        return PausedState()
    }
    
    func stop(player: MediaPlayer) -> PlayerState {
        player.stopPlayback()
        return StoppedState()
    }
}

class PausedState: PlayerState {
    func play(player: MediaPlayer) -> PlayerState {
        player.resumePlayback()
        return PlayingState()
    }
    
    func pause(player: MediaPlayer) -> PlayerState { self }
    
    func stop(player: MediaPlayer) -> PlayerState {
        player.stopPlayback()
        return StoppedState()
    }
}

class MediaPlayer {
    private var state: PlayerState = StoppedState()
    
    func play() { state = state.play(player: self) }
    func pause() { state = state.pause(player: self) }
    func stop() { state = state.stop(player: self) }
    
    func startPlayback() { print("▶️ Starting playback") }
    func pausePlayback() { print("⏸️ Pausing playback") }
    func resumePlayback() { print("▶️ Resuming playback") }
    func stopPlayback() { print("⏹️ Stopping playback") }
}
```

## When to Use ✅

- Object behavior depends on state
- Complex state-dependent conditionals
- State transitions follow rules
- Want to add new states easily

## When NOT to Use ❌

- Few states with simple logic
- State rarely changes
- States don't share common interface

## Related Patterns

- **Strategy**: Similar structure, swap algorithms
- **Singleton**: States often stateless singletons
- **Flyweight**: Share state objects
