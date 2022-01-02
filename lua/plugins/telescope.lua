local M = {}
M.setup = function(remap)
	local actions = require("telescope.actions")
	local state = require("telescope.actions.state")

	-- print("The value is" .. tostring(pcall(require, "telescope")))

	function OpenInDiffView(prompt_bufnr)
		actions.close(prompt_bufnr)
		local value = state.get_selected_entry(prompt_bufnr).value
		vim.cmd("DiffviewOpen " .. value .. "~1.." .. value)
	end

	require("telescope").setup({
		defaults = {
			hidden = true,
			layout_strategy = "vertical",
			file_ignore_patterns = { "node_modules", "package%-lock.json" },
			mappings = {
				i = {
					["<esc>"] = actions.close,
					["<C-j>"] = actions.cycle_history_next,
					["<C-k>"] = actions.cycle_history_prev,
				},
			},
		},
		pickers = {
			git_commits = {
				mappings = {
					i = {
						["<C-o>"] = OpenInDiffView,
						-- ["<CR>"] = OpenInDiffView (enter checks out branch)
					},
				},
			},
		},
	})

	remap({ "n", "<C-f>", ":lua require('telescope.builtin').live_grep({ hidden = true })<cr>" })
	remap({
		"n",
		"<C-j>",
		":lua require('telescope.builtin').git_files{ find_command = {'rg', '--files', '--hidden', '-g', '!node_modules/**'}}<cr>",
	})
	remap({ "n", "<C-b>", ":lua require('telescope.builtin').buffers({ hidden = true })<cr>" })
	remap({ "n", "<leader>tr", ":Telescope oldfiles<cr>" }) -- "recent files"
	remap({ "n", "<leader>td", ":Telescope diagnostics bufnr=0<cr>" })
	remap({ "n", "<leader>tgc", ":Telescope git_commits<cr>" })
	remap({ "n", "<leader>tgb", ":Telescope git_branches<cr>" })

	vim.cmd([[ nnoremap <expr> <leader>tf ':Telescope find_files<cr>' . expand('<cword>') ]])
	remap({ "v", "<leader>tf", "y<ESC>:Telescope find_files default_text=<c-r>0<CR>" })
	remap({ "n", "<leader>tF", ":Telescope grep_string<cr>" })
	remap({ "v", "<leader>tF", "y<ESC>:Telescope live_grep default_text=<c-r>0<CR>" })
end

return M
