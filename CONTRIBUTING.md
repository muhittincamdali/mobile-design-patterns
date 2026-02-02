# Contributing to Mobile Design Patterns

First off, thanks for taking the time to contribute! 🎉

## How Can I Contribute?

### Reporting Bugs

- Use the [Bug Report](https://github.com/muhittincamdali/mobile-design-patterns/issues/new?template=bug_report.yml) template
- Include the pattern name, category, and language
- Provide code snippets that demonstrate the issue

### Suggesting New Patterns

- Use the [Feature Request](https://github.com/muhittincamdali/mobile-design-patterns/issues/new?template=feature_request.yml) template
- Explain why the pattern is relevant to mobile development
- Include at least one real-world use case

### Submitting Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-pattern`)
3. Follow the existing file structure for pattern files
4. Include implementations in all three languages (Swift, Dart, TypeScript)
5. Add a Mermaid UML diagram
6. Commit your changes (`git commit -m 'feat: add mediator pattern'`)
7. Push to the branch (`git push origin feature/new-pattern`)
8. Open a Pull Request

## Pattern File Structure

Every pattern file must include:

```markdown
# Pattern Name

## Intent
## Problem
## Solution
## UML Diagram (Mermaid)
## Swift Implementation
## Dart Implementation
## TypeScript Implementation
## When to Use
## Real-World Examples
```

## Code Style

### Swift
- Follow [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/)
- Use `final class` where appropriate
- Prefer `struct` over `class` when possible
- Use Swift concurrency (`async/await`) for concurrency patterns

### Dart
- Follow [Effective Dart](https://dart.dev/effective-dart)
- Use null safety
- Prefer `final` variables
- Use factory constructors where appropriate

### TypeScript
- Use strict mode
- Prefer interfaces over type aliases for object shapes
- Use generics where it improves reusability
- Include proper type annotations

## Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` new pattern or implementation
- `fix:` bug fix in existing code
- `docs:` documentation only changes
- `refactor:` code restructuring
- `style:` formatting changes

## Code of Conduct

Please read our [Code of Conduct](CODE_OF_CONDUCT.md) before contributing.

## Questions?

Open a [discussion](https://github.com/muhittincamdali/mobile-design-patterns/discussions) or reach out via issues.
