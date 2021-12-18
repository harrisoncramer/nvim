local vim = vim
local execute = vim.api.nvim_command
local fn = vim.fn

-- Load local settings..
require("settings")
require("colors")
require("mappings")
require("functions")
require("autocommands")
require("lsp")
require("misc")

-- Load packer plugins
require("plugins")
