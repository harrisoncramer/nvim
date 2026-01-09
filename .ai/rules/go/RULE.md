---
globs: ['*.go']
alwaysApply: false
---

- Leave brief, helpful one-sentence comments on top of all exported functions.
- Almost all errors should be returned with additional context with fmt.Errorf, e.g. `return fmt.Errorf("failed to get user by ID: %w", err)`
- Prefer to use a "nil, err" pattern as the return type for most functions
