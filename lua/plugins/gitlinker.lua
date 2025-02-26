return {
	"ruifm/gitlinker.nvim",
	dependencies = "nvim-lua/plenary.nvim",
	config = function()
		require("gitlinker").setup({
			opts = {
				remote = nil,
				add_current_line_on_normal_mode = true,
				-- callback for what to do with the url
				action_callback = function(url)
					require("gitlinker.actions").copy_to_clipboard(url)
					require("notify")("Copied URL", vim.log.levels.INFO)
				end,
				-- print the url after performing the action
				print_url = false,
			},
			callbacks = {
				["github.com"] = require("gitlinker.hosts").get_github_type_url,
				["gitlab.com"] = require("gitlinker.hosts").get_gitlab_type_url,
			},
			mappings = "yg",
		})
	end,
}
