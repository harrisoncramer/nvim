# Neovim Configuration

![Editor](https://hjc-public.s3.amazonaws.com/nvim1.png?)

# About

This repository contains my configurations, including key mappings, plugins, and other settings for Neovim. I'm primarily working day-to-day in VueJS, React, Typescript, Go, Lua, and Clojure.

# Features

- Plugins managed with <a href="https://github.com/folke/lazy.nvim">lazy.nvim</a>
- Syntax highlighting with <a href="https://github.com/nvim-treesitter/nvim-treesitter">treesitter</a>
- LSPs installed via <a href="https://github.com/williamboman/mason.nvim">Mason</a> and configured via <a href="https://github.com/neovim/nvim-lspconfig">lspconfig</a>
- Debuggers installed and configured with <a href="https://github.com/mfussenegger/nvim-dap">nvim-dap</a>
- <a href="https://github.com/numToStr/FTerm.nvim">fterm</a> for terminal integration
- <a href="https://github.com/ibhagwan/fzf-lua">fzf-lua</a> for search
- <a href="https://github.com/harrisoncramer/gitlab.nvim">gitlab.nvim</a> for Gitlab integration
- <a href="https://github.com/sindrets/diffview.nvim">diffview</a> git branch/commit/diff viewing
- <a href="https://github.com/nvim-lualine/lualine.nvim">lualine</a> for status bar
- <a href="https://github.com/lukas-reineke/lsp-format.nvim">lsp-format</a> for formatting
- <a href="https://github.com/rebelot/kanagawa.nvim">kanagawa</a> colorscheme
- <a href="https://github.com/nvim-pack/nvim-spectre">spectre</a> for project-wide regexes

# Dependencies

There are a few dependencies for this editor configuration that cannot be installed within Neovim. I've detailed them below, installation instructions _assume an Ubuntu OS_, although installation on other operating systems should be straightforward. Most of them are required for LSPs or Debuggers to work.

1. Git version 2.36 or greater

```bash
sudo add-apt-repository ppa:git-core/ppa -y
sudo apt-get update -y
sudo apt install git -y
```

2. `npm` and `node`, which are used to install some of the LSPs and Debuggers. I recommend installing node via NVM (node version manager). You may need to resource your `.bashrc`/`.zshrc` after installing NVM for the command to be available in your path.

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
nvm install 20.5.0
```

3. The Treesitter CLI, which is required for syntax highlighting

```bash
npm install -g tree-sitter-cli
```

4. Go (required for Go Debugger + LSP). On Ubuntu:

```bash
sudo add-apt-repository ppa:longsleep/golang-backports -y
sudo apt update -y
sudo apt install golang-go -y
```

5. Zip/Unzip commands (required to unpack Typescript Debugger)

```bash
sudo apt install zip -y
```

6. The compiler `gcc`

```bash
sudo apt update -y
sudo apt install build-essential -y
```

7. ripgrep for fuzzy finding

```bash
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
sudo dpkg -i ripgrep_13.0.0_amd64.deb
```

8. bun for faster language servers (tailwindcss and ts_ls)
```bash
curl -fsSL https://bun.sh/install | bash
```

9. gnu-sed (for the <a href="https://github.com/nvim-pack/nvim-spectre">spectre</a> plugin)

# Quickstart

1. Install the required dependencies listed above.
2. Clone this repository to your Neovim configuration path: `git clone https://github.com/harrisoncramer/nvim.git ~/.config/nvim`
3. Open Neovim. The plugin installation should start automatically; so should the LSP and Debugger installations.

Please be patient when you first open up Neovim, it is installing many depndencies the first time it starts! I'd recommend going and getting a cup of coffee, the process can take ~5 minutes to install all of the debuggers, LSPs, and treesitter language parsers.

You can see the status of the plugin installation with the `:Lazy` command. This will open automatically. You can see the status of the LSP and Debugger installations with the `:Mason` command.
