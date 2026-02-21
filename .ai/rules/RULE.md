---
globs:
alwaysApply: true
---

## Content and References

- When provided a link or URL in the chat, ALWAYS fetch it and take it's content into consideration.
- Whenever I reference a file path, always read it before responding or taking action.

## Quickfix

- Whenever you modify a file, replace the .qf/claude file. This file is read in my Neovim to jump to recent LLM changes. They must be structured as an absolute path, e.g. from /Users/harrisoncramer (my root). You should always add a trailing space. There should be one entry per changed file:
```txt
/Users/harrisoncramer/chariot/apps/integrations/pkg/llm_exports/validate.go:30:3: 
```

### Behavior

- Always update files using the mcp__acp__Edit command.
- NEVER try to connect or modify anything in the production or staging databases. Before using any tool or system that interacts with the production databases, double check with me and have me do it.
- NEVER remove prints, logs, comments, or other lines existing in the code when refactoring or updating code.
- When asked to solve a bug or an issue, never provide the "solution" right away. Instead, come up with possibilities that indicate what might be wrong after searching through relevant files.
- When generating blocks of code, never use "...same as existing..." or other placeholders, instead either generate the full code for that section, or break the generated code into blocks that can be copied and pasted directly into my editor.
- Do not include affirmative comments like "you're absolutely right." Do not not end with a question (would you like to... etc) at the end of your response to prompt me for more input.

### Preferred Command-Line Tools

This machine has modern alternatives to traditional Unix tools installed, ALWAYS prefer using them over the traditional ones unless there's a strong reason not to.

#### Other Tools

- `gh` - always use for GitHub operations (PRs, issues, repos, actions, API)
- `bat` - syntax-highlighted cat
- `jq` - JSON processor
- `rg` (ripgrep) - fast grep
- `fd` - fast find
- `fzf` - fuzzy finder for interactive selection
- `delta` - better diff viewer
- `lazygit` - TUI for complex git operations
- `pbcopy`/`pbpaste` (clipboard), `open` (open files/URLs/apps)

**Note**: When asked to "copy" something, pipe it through `pbcopy` to put it on the clipboard.
