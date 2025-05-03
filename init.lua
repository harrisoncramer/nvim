-- Neovim Core Settings
require("globals")
require("settings")

-- Helper functions and autocommands
require("functions")
require("autocommands")
require("commands")

-- Plugins
require("lazyconfig")

-- Marks
require("marks")

-- Mappings
require("mappings")

-- Git helpers
require("git-helpers")

-- Work helpers
require("functions.work")

-- Diagnostic signs
require("diagnostics")

-- LSP
require("lsp")

-- Miscenalleous vim commands
vim.cmd.source("~/.config/nvim/_init.vim")
