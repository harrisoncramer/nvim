# Neovim Configuration

![Editor](https://hjc-public.s3.amazonaws.com/nvim1.png?)

# About

This repository contains my configurations, including key mappings, plugins, and other settings for Neovim. I'm primarily working day-to-day in VueJS, React, TypeScript, Go, Lua, and Clojure.

# Features

- Plugins managed with <a href="https://github.com/folke/lazy.nvim">lazy.nvim</a>
- Syntax highlighting with <a href="https://github.com/nvim-treesitter/nvim-treesitter">treesitter</a>
- LSPs installed with Mason + configured natively
- Debuggers installed and configured with <a href="https://github.com/mfussenegger/nvim-dap">nvim-dap</a>
- <a href="https://github.com/sindrets/diffview.nvim">diffview</a> git branch/commit/diff viewing
- <a href="https://github.com/nvim-lualine/lualine.nvim">lualine</a> for status bar
- <a href="https://github.com/rebelot/kanagawa.nvim">kanagawa</a> color scheme
- AI-assisted development with <a href="https://github.com/anthropics/claude-code">Claude Code</a>

# Dependencies

The configuration needs Neovim 0.12 or later, and won't load on anything older. It also needs a few programs that cannot be installed within Neovim, mostly for LSPs, Debuggers, and treesitter parsers.

Run `./check-tools` to see what is missing or too old. It never installs anything, so install what it lists with your own package manager.

A few commands shell out to optional programs that the editor can start without. When one is missing, the command that needs it shows a warning and does nothing.

# Quickstart

1. Clone this repository to your Neovim configuration path: `git clone https://github.com/harrisoncramer/nvim.git ~/.config/nvim`
2. Run `~/.config/nvim/check-tools` and install anything it reports missing.
3. Open Neovim. The plugin installation should start automatically; so should the LSP and Debugger installations.

Please be patient when you first open up Neovim, it is installing many dependencies the first time it starts! I'd recommend going and getting a cup of coffee, the process can take ~5 minutes to install all the debuggers, LSPs, and treesitter language parsers.

You can see the status of the plugin installation with the `:Lazy` command. This will open automatically. You can see the status of the LSP and Debugger installations with the `:Mason` command.
