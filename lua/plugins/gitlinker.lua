local map_opts = { noremap = true, silent = false, nowait = true, buffer = false }

vim.keymap.set("n", "yg", function()
	require("gitlinker.actions").copy_to_clipboard()
end, map_opts)

return {
	"ruifm/gitlinker.nvim",
	dependencies = "nvim-lua/plenary.nvim",
	config = function()
		require("gitlinker").setup({
			opts = {
				remote = nil,
				add_current_line_on_normal_mode = true,
				-- callback for what to do with the url
				action_callback = require("gitlinker.actions").copy_to_clipboard,
				-- print the url after performing the action
				print_url = false,
			},
			callbacks = {
				["github.com"] = require("gitlinker.hosts").get_github_type_url,
				["gitlab.com"] = require("gitlinker.hosts").get_gitlab_type_url,
			},
			mappings = "gy",
		})
	end,
}
