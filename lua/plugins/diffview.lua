local u = require("functions.utils")
local diffview = require("diffview")

return {
	copy_hash_and_open = function()
		diffview.trigger_event("copy_hash")
		local global_register = u.get_register(u.get_os() == "Linux" and "+" or "*")
		diffview.trigger_event("goto_file_tab")
		local file_name = vim.fn.expand("%")
		vim.cmd(":Gedit " .. global_register .. ":%")
		vim.cmd(":vert diffsplit " .. file_name)
	end,
	setup = function()
		local cb = require("diffview.config").diffview_callback

		local go_to_git_file = function()
			return ':lua require("plugins.diffview").copy_hash_and_open()<CR>'
		end

		vim.keymap.set("n", "<leader>df", ":DiffviewFileHistory<CR>")

		diffview.setup({
			diff_binaries = false,
			use_icons = true, -- Requires nvim-web-devicons
			icons = {
				folder_closed = "",
				folder_open = "",
			},
			signs = { fold_closed = "", fold_open = "" },
			file_panel = {
				listing_style = "tree", -- One of 'list' or 'tree'
				tree_options = { -- Only applies when listing_style is 'tree'
					flatten_dirs = true, -- Flatten dirs that only contain one single dir
					folder_statuses = "only_folded", -- One of 'never', 'only_folded' or 'always'.
				},
			},
			default_args = { -- Default args prepended to the arg-list for the listed commands
				DiffviewOpen = {},
				DiffviewFileHistory = {
					-- Follow only the first parent upon seeing a merge commit.
					first_parent = true,
					-- Include all refs.
					all = true,
					-- List only merge commits.
					merges = false,
					-- List commits in reverse order.
					reverse = false,
				},
			},
			hooks = {}, -- See ':h diffview-config-hooks'
			key_bindings = {
				disable_defaults = false, -- Disable the default key bindings
				-- The `view` bindings are active in the diff buffers, only when the current
				-- tabpage is a Diffview.
				view = {
					["<C-n>"] = cb("select_next_entry"), -- Open the diff for the next file
					["<C-p>"] = cb("select_prev_entry"), -- Open the diff for the previous file
					["<CR>"] = cb("goto_file_edit"), -- Open the file in a new split in previous tabpage
					["<C-w><C-f>"] = cb("goto_file_split"), -- Open the file in a new split
					["<C-w>gf"] = cb("goto_file_tab"), -- Open the file in a new tabpage
					["<leader>e"] = cb("focus_files"), -- Bring focus to the files panel
					["<leader>b"] = cb("toggle_files"), -- Toggle the files panel.
				},
				file_panel = {
					["j"] = cb("next_entry"), -- Bring the cursor to the next file entry
					["<down>"] = cb("next_entry"),
					["k"] = cb("prev_entry"), -- Bring the cursor to the previous file entry.
					["<up>"] = cb("prev_entry"),
					["<cr>"] = cb("select_entry"), -- Open the diff for the selected entry.
					["o"] = cb("select_entry"),
					["<2-LeftMouse>"] = cb("select_entry"),
					["-"] = cb("toggle_stage_entry"), -- Stage / unstage the selected entry.
					["S"] = cb("stage_all"), -- Stage all entries.
					["U"] = cb("unstage_all"), -- Unstage all entries.
					["X"] = cb("restore_entry"), -- Restore entry to the state on the left side.
					["R"] = cb("refresh_files"), -- Update stats and entries in the file list.
					["<C-n>"] = cb("select_next_entry"),
					["<C-p>"] = cb("select_prev_entry"),
					["gf"] = cb("goto_file"),
					["<CR>"] = cb("goto_file_edit"),
					["<C-w><C-f>"] = cb("goto_file_split"),
					["<C-w>gf"] = cb("goto_file_tab"),
					["i"] = cb("listing_style"), -- Toggle between 'list' and 'tree' views
					["f"] = cb("toggle_flatten_dirs"), -- Flatten empty subdirectories in tree listing style.
					["<leader>e"] = cb("focus_files"),
					["<leader>b"] = cb("toggle_files"),
				},
				file_history_panel = {
					["g!"] = cb("options"), -- Open the option panel
					["<C-A-d>"] = cb("open_in_diffview"), -- Open the entry under the cursor in a diffview
					["<C-o>"] = go_to_git_file(), -- Open the file and the file from the commit side by side, editable, in a vimdiff
					["zR"] = cb("open_all_folds"),
					["zM"] = cb("close_all_folds"),
					["j"] = cb("next_entry"),
					["<down>"] = cb("next_entry"),
					["k"] = cb("prev_entry"),
					["<up>"] = cb("prev_entry"),
					["<cr>"] = cb("select_entry"),
					["o"] = cb("select_entry"),
					["<2-LeftMouse>"] = cb("select_entry"),
					["<C-n>"] = cb("select_next_entry"),
					["<C-p>"] = cb("select_prev_entry"),
					["gf"] = cb("goto_file"),
					["<C-w><C-f>"] = cb("goto_file_split"),
					["<C-w>gf"] = cb("goto_file_tab"),
					["<leader>e"] = cb("focus_files"),
					["<leader>b"] = cb("toggle_files"),
				},
				option_panel = { ["<tab>"] = cb("select"), ["q"] = cb("close") },
			},
		})
	end,
}
