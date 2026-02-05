# Facade Pattern

> Provide unified interface to a set of interfaces in a subsystem

## Problem

- Complex subsystem with many classes
- Client needs simple interface
- Want to decouple subsystem from clients

## Solution

```swift
// MARK: - Complex Subsystem Classes
class VideoDecoder {
    func decode(_ file: VideoFile) -> DecodedVideo {
        print("Decoding video: \(file.name)")
        return DecodedVideo(frames: [], duration: file.duration)
    }
}

class AudioDecoder {
    func decode(_ file: VideoFile) -> DecodedAudio {
        print("Decoding audio from: \(file.name)")
        return DecodedAudio(samples: [], sampleRate: 44100)
    }
}

class SubtitleParser {
    func parse(_ file: SubtitleFile?) -> [Subtitle] {
        guard let file = file else { return [] }
        print("Parsing subtitles: \(file.name)")
        return file.subtitles
    }
}

class VideoRenderer {
    func render(_ video: DecodedVideo, to surface: RenderSurface) {
        print("Rendering video to surface")
    }
}

class AudioRenderer {
    func render(_ audio: DecodedAudio, to output: AudioOutput) {
        print("Rendering audio")
    }
}

class SyncEngine {
    func synchronize(video: VideoRenderer, audio: AudioRenderer) {
        print("Synchronizing A/V playback")
    }
}

// MARK: - Facade
class MediaPlayerFacade {
    private let videoDecoder = VideoDecoder()
    private let audioDecoder = AudioDecoder()
    private let subtitleParser = SubtitleParser()
    private let videoRenderer = VideoRenderer()
    private let audioRenderer = AudioRenderer()
    private let syncEngine = SyncEngine()
    
    private var currentVideo: DecodedVideo?
    private var currentAudio: DecodedAudio?
    private var isPlaying = false
    
    private let renderSurface: RenderSurface
    private let audioOutput: AudioOutput
    
    init(renderSurface: RenderSurface, audioOutput: AudioOutput) {
        self.renderSurface = renderSurface
        self.audioOutput = audioOutput
    }
    
    // MARK: - Simple Public Interface
    func play(file: VideoFile, subtitles: SubtitleFile? = nil) {
        currentVideo = videoDecoder.decode(file)
        currentAudio = audioDecoder.decode(file)
        let subs = subtitleParser.parse(subtitles)
        
        if let video = currentVideo {
            videoRenderer.render(video, to: renderSurface)
        }
        
        if let audio = currentAudio {
            audioRenderer.render(audio, to: audioOutput)
        }
        
        syncEngine.synchronize(video: videoRenderer, audio: audioRenderer)
        isPlaying = true
    }
    
    func pause() {
        isPlaying = false
    }
    
    func resume() {
        isPlaying = true
    }
    
    func stop() {
        isPlaying = false
        currentVideo = nil
        currentAudio = nil
    }
    
    func seek(to time: TimeInterval) {
        // Complex seeking logic hidden
    }
    
    func setVolume(_ volume: Float) {
        audioOutput.volume = volume
    }
}

// MARK: - Usage
let player = MediaPlayerFacade(
    renderSurface: videoView,
    audioOutput: AudioOutput.default
)

player.play(file: videoFile, subtitles: subtitleFile)
player.setVolume(0.8)
player.seek(to: 120)
player.pause()
```

## Checkout Facade Example

```swift
class CheckoutFacade {
    private let cart: CartService
    private let inventory: InventoryService
    private let payment: PaymentService
    private let shipping: ShippingService
    private let notification: NotificationService
    private let analytics: AnalyticsService
    
    init(
        cart: CartService,
        inventory: InventoryService,
        payment: PaymentService,
        shipping: ShippingService,
        notification: NotificationService,
        analytics: AnalyticsService
    ) {
        self.cart = cart
        self.inventory = inventory
        self.payment = payment
        self.shipping = shipping
        self.notification = notification
        self.analytics = analytics
    }
    
    func checkout(
        paymentMethod: PaymentMethod,
        shippingAddress: Address
    ) async throws -> Order {
        // 1. Validate cart
        let items = try await cart.getItems()
        guard !items.isEmpty else {
            throw CheckoutError.emptyCart
        }
        
        // 2. Check inventory
        for item in items {
            guard try await inventory.isAvailable(item.productId, quantity: item.quantity) else {
                throw CheckoutError.outOfStock(item.productId)
            }
        }
        
        // 3. Calculate shipping
        let shippingCost = try await shipping.calculateCost(items: items, to: shippingAddress)
        
        // 4. Process payment
        let total = items.reduce(0) { $0 + $1.price * Decimal($1.quantity) } + shippingCost
        let paymentResult = try await payment.charge(amount: total, method: paymentMethod)
        
        // 5. Reserve inventory
        for item in items {
            try await inventory.reserve(item.productId, quantity: item.quantity)
        }
        
        // 6. Create order
        let order = Order(
            items: items,
            total: total,
            paymentId: paymentResult.transactionId,
            shippingAddress: shippingAddress
        )
        
        // 7. Schedule shipping
        try await shipping.schedule(order: order)
        
        // 8. Clear cart & notify
        try await cart.clear()
        await notification.sendOrderConfirmation(order)
        analytics.track(.purchase(order: order))
        
        return order
    }
}
```

## When to Use ✅

- Simplify complex subsystem
- Layer subsystems
- Decouple client from subsystem
- Provide entry point to subsystem

## When NOT to Use ❌

- Subsystem is already simple
- Client needs fine-grained control
- Facade becomes too large (split it)

## Related Patterns

- **Adapter**: Changes interface, Facade simplifies
- **Mediator**: Coordinates object communication
- **Singleton**: Facade often implemented as singleton
