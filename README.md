# Neovim Configuration

![The editor](https://hjc-public.s3.amazonaws.com/nvim3.png)
![Terminal integration](https://hjc-public.s3.amazonaws.com/nvim2.png)
![Diffing](https://hjc-public.s3.amazonaws.com/nvim1.png)

# Quickstart

1. Install Packer: `git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim`
2. Install this Repo: `git clone https://github.com/harrisoncramer/neovim-settings.git ~/.config/nvim`
3. Open Neovim, and install the dependencies with `:PackerSync`
4. Restart Neovim.
5. Profit.

# About

This repository contains my configurations, including key mappings, plugins, and other settings for Neovim. I'm primarily working day-to-day with Javascript, Typescript, React, Vue, Clojure, and Lua.

# Features

- Native LSP w/ <a href="https://github.com/nvim-treesitter/nvim-treesitter">treesitter</a>
- LSPs via <a href="https://github.com/williamboman/nvim-lsp-installer">lsp-installer</a> and configured w/ <a href="https://github.com/neovim/nvim-lspconfig">lspconfig</a>
- <a href="https://github.com/numToStr/FTerm.nvim">fterm</a> for terminal integration
- <a href="https://github.com/nvim-telescope/telescope.nvim/issues">telescope</a> for search
- <a href="https://github.com/sindrets/diffview.nvim">diffview</a> git branch/commit/diff viewing
- <a href="https://github.com/tpope/vim-fugitive">fugitive</a> for git commits and pushes
- <a href="https://github.com/nvim-lualine/lualine.nvim">lualine</a> for status bar
- <a href="https://github.com/jose-elias-alvarez/null-ls.nvim">null-ls</a> for formatting
- <a href="https://github.com/rebelot/kanagawa.nvim">kanagawa</a> colorscheme

# Dependencies

- <a href="https://github.com/BurntSushi/ripgrep">ripgrep</a>
- <a href="https://github.com/junegunn/fzf">fzf</a>
- <a href="https://github.com/neovim/pynvim">pynvim</a>
- Node (I'd recommend using <a href="https://github.com/Schniz/fnm">fnm</a>)
