lua require("settings")
lua require("plugins")
lua require("colors")
lua require("mappings")
lua require("functions")
lua require("autocommands")

lua require("pluginSettings/fzf")
lua require("pluginSettings/fugitive")
lua require("pluginSettings/ultisnips")
lua require("pluginSettings/coc")
source $HOME/.config/nvim/plugin-settings.vim " Should come last...
