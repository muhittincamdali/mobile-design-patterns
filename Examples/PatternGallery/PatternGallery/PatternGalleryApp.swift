import MobilePatterns
import SwiftUI

@main
struct PatternGalleryApp: App {
    var body: some Scene {
        WindowGroup {
            GalleryView(initialPath: LaunchOptions.initialPath, link: LaunchOptions.link)
        }
    }
}

/// Launch arguments for scripts/capture-screens.sh and for trying links on a simulator:
/// `-screen articles|article|checkout|editor|links|cart` opens one screen directly, and
/// `-link <url>` opens a deep link through the same path as `onOpenURL`.
enum LaunchOptions {
    static var link: URL? {
        UserDefaults.standard.string(forKey: "link").flatMap(URL.init(string:))
    }

    static var initialPath: [AppRoute] {
        switch UserDefaults.standard.string(forKey: "screen") {
        case "articles": [.articles]
        case "article": [.articles, .article(id: 1)]
        case "checkout": [.checkout]
        case "editor": [.editor]
        case "links": [.links]
        case "cart": [.cart]
        default: []
        }
    }
}
