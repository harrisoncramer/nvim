local getVisualSelection = require("functions").getVisualSelection

return {
	setup = function(remap)
		local actions = require("telescope.actions")
		local state = require("telescope.actions.state")

		local function SeeCommitChangesInDiffview(prompt_bufnr)
			actions.close(prompt_bufnr)
			local value = state.get_selected_entry(prompt_bufnr).value
			vim.cmd("DiffviewOpen " .. value .. "~1.." .. value)
		end

		local function CompareWithCurrentBranchInDiffview(prompt_bufnr)
			actions.close(prompt_bufnr)
			local value = state.get_selected_entry(prompt_bufnr).value
			vim.cmd("DiffviewOpen " .. value)
		end

		local function CopyTextFromPreview(prompt_bufnr)
			local selection = require("telescope.actions.state").get_selected_entry()
			local text = vim.fn.trim(selection["text"])
			vim.fn.setreg('"', text)
			actions.close(prompt_bufnr)
		end

		local function CopyCommitHash(prompt_bufnr)
			local selection = require("telescope.actions.state").get_selected_entry()
			vim.fn.setreg('"', selection.value)
			actions.close(prompt_bufnr)
		end

		local function CopyBranchName(prompt_bufnr)
			local selection = require("telescope.actions.state").get_selected_entry()
			vim.fn.setreg('"', selection.value)
			actions.close(prompt_bufnr)
		end

		require("telescope").setup({
			defaults = {
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
				git_files = {
					prompt_prefix = " ",
					find_command = { "rg", "--files", "--hidden", "-g", "!node_modules/**" },
				},
				git_branches = {
					prompt_prefix = " ",
					mappings = {
						i = {
							["<C-y>"] = CopyBranchName,
						},
					},
				},
				live_grep = {
					prompt_prefix = " ",
					find_command = { "rg", "-g", "!node_modules/**" },
					mappings = {
						i = {
							["<C-y>"] = CopyTextFromPreview,
						},
					},
				},
				oldfiles = {
					prompt_prefix = " ",
				},
				grep_string = {
					prompt_prefix = " ",
				},
				buffers = {
					hidden = true,
				},
				git_commits = {
					prompt_prefix = " ",
					mappings = {
						i = {
							["<C-y>"] = CopyCommitHash,
							["<C-o>"] = SeeCommitChangesInDiffview,
							["<C-c>"] = CompareWithCurrentBranchInDiffview,
						},
					},
				},
			},
		})

		local builtin = require("telescope.builtin")

		local function live_grep()
			builtin.live_grep()
		end

		local function git_files()
			local ok = pcall(builtin.git_files)
			if not ok then
				require("telescope.builtin").find_files()
			end
		end

		local function buffers()
			builtin.buffers()
		end

		local function oldfiles()
			builtin.oldfiles()
		end

		local function git_commits()
			builtin.git_commits()
		end

		local function git_branches()
			builtin.git_branches()
		end

		local function git_stash()
			builtin.git_stash()
		end

		local function grep_string()
			local word = vim.fn.expand("<cword>")
			builtin.grep_string()
			vim.api.nvim_feedkeys(word, "i", false)
		end

		local function git_files_string()
			local word = vim.fn.expand("<cword>")
			builtin.git_files()
			vim.api.nvim_feedkeys(word, "i", false)
		end

		local function git_files_string_visual()
			local text = getVisualSelection()
			vim.api.nvim_input("<esc>")
			if text[1] == nil then
				print("No appropriate visual selection found")
			else
				builtin.git_files()
				vim.api.nvim_input(text[1])
			end
		end

		local function grep_string_visual()
			local text = getVisualSelection()
			vim.api.nvim_input("<esc>")
			if text[1] == nil then
				print("No appropriate visual selection found")
			else
				builtin.grep_string()
				vim.api.nvim_input(text[1])
				vim.api.nvim_feedkeys(text, "i", false)
			end
		end

		vim.keymap.set("n", "<C-f>", live_grep)
		vim.keymap.set("n", "<C-j>", git_files)
		vim.keymap.set("n", "<C-g>", buffers)
		vim.keymap.set("n", "<leader>tr", oldfiles)
		vim.keymap.set("n", "<leader>tgc", git_commits)
		vim.keymap.set("n", "<leader>tgb", git_branches)
		vim.keymap.set("n", "<leader>tgs", git_stash)
		vim.keymap.set("n", "<leader>tF", grep_string)
		vim.keymap.set("n", "<leader>tf", git_files_string)
		vim.keymap.set("v", "<leader>tf", git_files_string_visual)
		vim.keymap.set("v", "<leader>tF", grep_string_visual)
	end,
}
