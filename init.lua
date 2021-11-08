-- Main Imports
require("settings")
require("plugins")
require("colors")
require("mappings")
require("functions")
require("autocommands")

-- Packer
require("packer")
require("packer-plugins")

-- Plugin-specific settings
require("plugin/fzf")
require("plugin/fugitive")
require("plugin/ultisnips")
require("plugin/coc")
require("plugin/treesitter")
require("plugin/miscellaneous")
require("plugin/toggle-terminal")
