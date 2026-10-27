// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "MobilePatterns",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "MobilePatterns", targets: ["MobilePatterns"])
    ],
    targets: [
        .target(
            name: "MobilePatterns",
            path: "Sources/MobilePatterns"
        ),
        .testTarget(
            name: "MobilePatternsTests",
            dependencies: ["MobilePatterns"]
        )
    ]
)
