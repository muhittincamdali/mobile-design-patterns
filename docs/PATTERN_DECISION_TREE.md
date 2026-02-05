# Pattern Decision Tree

> Interactive guide to choosing the right design pattern

## Quick Decision Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    WHAT'S YOUR PROBLEM?                         │
└─────────────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        ▼                     ▼                     ▼
   CREATING              STRUCTURING           COMMUNICATING
   OBJECTS?              OBJECTS?              BETWEEN OBJECTS?
        │                     │                     │
        ▼                     ▼                     ▼
   [Creational]          [Structural]          [Behavioral]
```

---

## Creational Patterns

```
Need to create objects?
│
├── Only ONE instance ever?
│   └── YES → Singleton
│
├── Don't know exact class until runtime?
│   ├── Single type of product → Factory Method
│   └── Family of related products → Abstract Factory
│
├── Complex object with many options?
│   └── YES → Builder
│
├── Need to copy existing objects?
│   └── YES → Prototype
│
├── Want to decouple dependencies?
│   └── YES → Dependency Injection
│
└── Expensive objects created frequently?
    └── YES → Object Pool
```

---

## Structural Patterns

```
Need to organize objects?
│
├── Convert one interface to another?
│   └── YES → Adapter
│
├── Add functionality without changing class?
│   ├── At runtime, stackable → Decorator
│   └── Control access → Proxy
│
├── Simplify complex subsystem?
│   └── YES → Facade
│
├── Many similar objects sharing data?
│   └── YES → Flyweight
│
├── Separate abstraction from implementation?
│   └── YES → Bridge
│
└── Tree-like hierarchies?
    └── YES → Composite
```

---

## Behavioral Patterns

```
Need to manage behavior/communication?
│
├── React to state changes?
│   ├── One-to-many → Observer
│   └── Many-to-many → Mediator
│
├── Swap algorithms at runtime?
│   └── YES → Strategy
│
├── Object behavior depends on state?
│   └── YES → State
│
├── Need undo/redo or queue operations?
│   └── YES → Command
│
├── Process requests in chain?
│   └── YES → Chain of Responsibility
│
├── Save/restore object state?
│   └── YES → Memento
│
└── Define algorithm skeleton?
    └── YES → Template Method
```

---

## Mobile-Specific Patterns

```
Mobile app problem?
│
├── Navigation spaghetti?
│   └── YES → Coordinator
│
├── Multiple data sources?
│   └── YES → Repository
│
├── UI state management?
│   └── YES → View State / MVVM
│
├── Feature toggles needed?
│   └── YES → Feature Flag
│
├── Deep linking required?
│   └── YES → Coordinator + Deep Link Handler
│
└── Offline support needed?
    └── YES → Repository + Cache Strategy
```

---

## Pattern Comparison Tables

### Creational Patterns

| Pattern | Use When | Avoid When |
|---------|----------|------------|
| Singleton | Need exactly one instance | Multiple instances needed |
| Factory | Don't know class at compile time | Simple direct instantiation works |
| Abstract Factory | Create families of objects | Single product type |
| Builder | Complex object, many parameters | Simple object |
| Prototype | Clone existing objects | Simple copy suffices |
| Object Pool | Expensive objects, high frequency | Cheap object creation |

### Structural Patterns

| Pattern | Use When | Avoid When |
|---------|----------|------------|
| Adapter | Incompatible interfaces | You control both interfaces |
| Decorator | Add behavior dynamically | Single fixed behavior |
| Proxy | Control access, lazy loading | Direct access is fine |
| Facade | Simplify complex API | API is already simple |
| Composite | Tree structures | Flat collections |
| Bridge | Vary abstraction & implementation | Single implementation |

### Behavioral Patterns

| Pattern | Use When | Avoid When |
|---------|----------|------------|
| Observer | Notify multiple objects | Single listener |
| Strategy | Swap algorithms | Single algorithm |
| State | Behavior depends on state | Few simple states |
| Command | Undo/redo, queuing | Simple one-off actions |
| Chain of Responsibility | Multiple handlers | Single handler |
| Mediator | Complex interactions | Simple peer-to-peer |

---

## Real-World Examples

### E-Commerce App

| Feature | Pattern |
|---------|---------|
| Payment methods | Strategy |
| Product catalog | Repository |
| Checkout flow | Coordinator |
| Cart management | Observer |
| Order status | State |

### Social Media App

| Feature | Pattern |
|---------|---------|
| Feed loading | Repository + Pagination |
| Post creation | Builder |
| Navigation | Coordinator |
| Like/Comment updates | Observer |
| Image caching | Proxy |

### Banking App

| Feature | Pattern |
|---------|---------|
| Authentication | State |
| Transaction history | Repository |
| Money transfer | Command |
| Account types | Factory |
| Security layers | Decorator |

---

## Anti-Pattern Recognition

### Don't Use Patterns When...

1. **Premature Optimization** - Simple code works fine
2. **Pattern Obsession** - Using patterns for patterns' sake
3. **Wrong Pattern** - Square peg, round hole
4. **Over-Engineering** - Simple CRUD doesn't need VIPER

### Signs You Need a Pattern

1. ✅ Code is hard to test
2. ✅ Too many if/switch statements
3. ✅ Changes ripple across codebase
4. ✅ Duplicated logic
5. ✅ Classes with 500+ lines
6. ✅ Can't swap implementations
