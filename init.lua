-- Neovim Core Settings
require("settings")

-- Helper functions and autocommands
require("functions")
require("autocommands")
require("commands")

-- Plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup("plugins", {
  change_detection = {
    enabled = true,
    notify = false,
  },
  dev = {
    path = vim.fn.stdpath("config") .. "/dev-plugins",
    patterns = { "harrisoncramer" },
    fallback = false, -- Fallback to git when local plugin doesn't exist
  },
})

-- Mappings
require("mappings")

-- Language Servers
require("lsp")
