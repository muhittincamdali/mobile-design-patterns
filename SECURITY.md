# Security policy

## Supported versions

| Version | Supported                        |
| ------- | -------------------------------- |
| 2.x     | Yes                              |
| 1.x     | No (documentation only, no code) |

## Reporting a vulnerability

Report it privately through
[GitHub private vulnerability reporting](https://github.com/muhittincamdali/mobile-design-patterns/security/advisories/new),
not in a public issue. Include the type involved, a test or snippet that shows the problem, and
the version or commit.

You will get an answer within seven days. Fixes are released as a patch version with a
CHANGELOG entry and, when users need to act, a GitHub security advisory.

## Scope

The types most relevant to security are the ones that handle input from outside the app:

- `DeepLinkParser`: scheme and host allowlists, credentials, `.` and `..` segments, `/` and `\`
  encoded inside a segment, percent encoding, control characters, and size limits on URLs,
  segments and query items.
- `RequestBuilder`: header names and values (header injection), path segment and query
  encoding, base URL checks.

A way to get a URL past `DeepLinkParser` that its documentation says it refuses, or to inject a
header through `RequestBuilder`, is a vulnerability. So is unbounded memory growth in a type that
documents a limit (`Router`, `Repository`, `UndoStack`, `Broadcaster`).

The example app's sample data and the `example.com` hosts in samples are placeholders, not
services.
