# Prototype Pattern

> Clone existing objects without coupling to their classes

## Problem

- Need to copy complex objects
- Object creation is expensive
- Want to avoid knowing concrete classes

## Solution

```swift
// MARK: - Prototype Protocol
protocol Prototype: AnyObject {
    func clone() -> Self
}

// MARK: - Document Example
class Document: Prototype {
    var title: String
    var content: String
    var formatting: TextFormatting
    var images: [ImageAttachment]
    var metadata: DocumentMetadata
    
    init(
        title: String,
        content: String = "",
        formatting: TextFormatting = TextFormatting(),
        images: [ImageAttachment] = [],
        metadata: DocumentMetadata = DocumentMetadata()
    ) {
        self.title = title
        self.content = content
        self.formatting = formatting
        self.images = images
        self.metadata = metadata
    }
    
    func clone() -> Self {
        let copy = Document(
            title: "\(title) (Copy)",
            content: content,
            formatting: formatting.clone(),
            images: images.map { $0.clone() },
            metadata: metadata.clone()
        )
        return copy as! Self
    }
}

class TextFormatting: Prototype {
    var font: String
    var fontSize: CGFloat
    var isBold: Bool
    var isItalic: Bool
    
    init(font: String = "System", fontSize: CGFloat = 14, isBold: Bool = false, isItalic: Bool = false) {
        self.font = font
        self.fontSize = fontSize
        self.isBold = isBold
        self.isItalic = isItalic
    }
    
    func clone() -> Self {
        TextFormatting(font: font, fontSize: fontSize, isBold: isBold, isItalic: isItalic) as! Self
    }
}

class ImageAttachment: Prototype {
    var imageName: String
    var position: CGPoint
    var size: CGSize
    
    init(imageName: String, position: CGPoint, size: CGSize) {
        self.imageName = imageName
        self.position = position
        self.size = size
    }
    
    func clone() -> Self {
        ImageAttachment(imageName: imageName, position: position, size: size) as! Self
    }
}

class DocumentMetadata: Prototype {
    var author: String
    var createdAt: Date
    var tags: [String]
    
    init(author: String = "", createdAt: Date = Date(), tags: [String] = []) {
        self.author = author
        self.createdAt = createdAt
        self.tags = tags
    }
    
    func clone() -> Self {
        DocumentMetadata(author: author, createdAt: Date(), tags: tags) as! Self
    }
}

// MARK: - Prototype Registry
class DocumentTemplateRegistry {
    private var templates: [String: Document] = [:]
    
    func register(_ template: Document, forKey key: String) {
        templates[key] = template
    }
    
    func createDocument(from templateKey: String) -> Document? {
        templates[templateKey]?.clone()
    }
    
    static let shared: DocumentTemplateRegistry = {
        let registry = DocumentTemplateRegistry()
        
        // Register templates
        let resumeTemplate = Document(title: "Resume")
        resumeTemplate.formatting = TextFormatting(font: "Helvetica", fontSize: 12)
        resumeTemplate.metadata.tags = ["professional", "resume"]
        registry.register(resumeTemplate, forKey: "resume")
        
        let reportTemplate = Document(title: "Report")
        reportTemplate.formatting = TextFormatting(font: "Times New Roman", fontSize: 14)
        reportTemplate.metadata.tags = ["business", "report"]
        registry.register(reportTemplate, forKey: "report")
        
        return registry
    }()
}

// MARK: - Usage
// Clone from template
if let newResume = DocumentTemplateRegistry.shared.createDocument(from: "resume") {
    newResume.title = "John's Resume"
    newResume.content = "Professional experience..."
}

// Clone existing document
let originalDoc = Document(title: "My Document")
originalDoc.content = "Important content"
let duplicate = originalDoc.clone() // Deep copy
```

## NSCopying Implementation

```swift
class ConfigurableCell: NSObject, NSCopying {
    var backgroundColor: UIColor
    var cornerRadius: CGFloat
    var shadowOpacity: Float
    
    init(backgroundColor: UIColor, cornerRadius: CGFloat, shadowOpacity: Float) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.shadowOpacity = shadowOpacity
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        ConfigurableCell(
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            shadowOpacity: shadowOpacity
        )
    }
}
```

## When to Use ✅

- Object creation is expensive
- Need copies with slight variations
- Avoid subclass proliferation
- Runtime object configuration

## When NOT to Use ❌

- Objects have circular references
- Simple value types (use struct instead)
- Objects don't need copying

## Related Patterns

- **Factory Method**: Alternative creation approach
- **Memento**: Save/restore state (not clone)
- **Composite**: Often used with prototype for tree structures
