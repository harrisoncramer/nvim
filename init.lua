-- Basic Settings
_G.vim_version = vim.version().minor
if vim_version < 7 then
	vim.keymap = {
		set = function() end,
	}
end

require("settings")

-- Language Server
require("lsp")

-- Other Mappings and Settings
require("colors")
require("mappings")
require("functions")
require("autocommands")
require("misc")

-- Packer plugins
require("plugins")
