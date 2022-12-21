# Neovim Configuration

![The editor](https://hjc-public.s3.amazonaws.com/nvim3.png)
![Terminal integration](https://hjc-public.s3.amazonaws.com/nvim2.png)
![Diffing](https://hjc-public.s3.amazonaws.com/nvim1.png)
![Debugging](https://harrisoncramer.me/static/6e0f346fac366e6835391c95b69aa43a/d61c2/nvim-dap-ui-go.png)

# About

This repository contains my configurations, including key mappings, plugins, and other settings for Neovim. I'm primarily working day-to-day in VueJS, React, Typescript, Golang, Lua, and Clojure.

# Dependencies

There are a few dependenceis for this editor configuration that cannot be installed within Neovim. I've detailed them below, installation instructions _assume an Ubuntu OS_, although installation on other operating systems should be straightforward. Most of them are required for LSPs or Debuggers to work.

1. `npm` and `node`, which are used to install some of the LSPs and Debuggers. I recommend installing node via NVM (node version manager). You may need to resource your `.bashrc`/`.zshrc` after installing NVM for the command to be available in your path.

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
nvm install 16.0.0
```

2. The Treesitter CLI, which is required for syntax highlighting

```bash
npm install -g tree-sitter-cli`
```

3. Golang (required for Golang Debugger + LSP). On Ubuntu:

```bash
sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt update
sudo apt install golang-go
```

4. Zip/Unzip commands (required to unpack Typescript Debugger)

```bash
sudo apt install zip
```

5. The compiler `gcc`

```bash
sudo apt update
sudo apt install build-essential
```

# Quickstart

1. Install the required dependencies listed above.
2. Clone this repository to your Neovim configuration path: `cit clone https://github.com/harrisoncramer/nvim.git ~/.config/nvim`
3. Open Neovim. The plugin installation should start automatically; so should the LSP and Debugger installations.

Please be patient when you first open up Neovim, it is installing many depndencies the first time it starts! I'd recommend going and getting a cup of coffee, the process can take ~5 minutes to install all of the debuggers, LSPs, and treesitter language parsers.

You can see the status of the plugin installation with the `:Lazy` command. This will open automatically. You can see the status of the LSP and Debugger installations with the `:Mason` command.


# Features

- Plugins managed with <a href="https://github.com/folke/lazy.nvim">lazy.nvim</a>
- Syntax highlighting with <a href="https://github.com/nvim-treesitter/nvim-treesitter">treesitter</a>
- LSPs installed via <a href="https://github.com/williamboman/mason.nvim">Mason</a> and configured via <a href="https://github.com/neovim/nvim-lspconfig">lspconfig</a>
- Debuggers installed and configured with <a href="https://github.com/mfussenegger/nvim-dap">nvim-dap</a>
- <a href="https://github.com/numToStr/FTerm.nvim">fterm</a> for terminal integration
- <a href="https://github.com/nvim-telescope/telescope.nvim/issues">telescope</a> for search
- <a href="https://github.com/sindrets/diffview.nvim">diffview</a> git branch/commit/diff viewing
- <a href="https://github.com/tpope/vim-fugitive">fugitive</a> for git commits and pushes
- <a href="https://github.com/nvim-lualine/lualine.nvim">lualine</a> for status bar
- <a href="https://github.com/lukas-reineke/lsp-format.nvim">lsp-format</a> for formatting
- <a href="https://github.com/rebelot/kanagawa.nvim">kanagawa</a> colorscheme
