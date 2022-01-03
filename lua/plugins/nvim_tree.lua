return {
	setup = function(remap)
		remap({ "n", "<leader>;", ":NvimTreeToggle<CR>" })

		-- Dummy function used for cancelling default mappings
		local function cancel()
			return nil
		end

		vim.g.nvim_tree_root_folder_modifier = 1
		vim.g.nvim_tree_highlight_opened_files = 0
		vim.g.nvim_tree_git_hl = 1
		vim.g.nvim_tree_indent_markers = 0
		vim.g.nvim_tree_quit_on_open = 0
		vim.g.nvim_tree_root_folder_modifier = ":~"
		vim.g.nvim_tree_add_trailing = 0
		vim.g.nvim_tree_group_empty = 1
		vim.g.nvim_tree_disable_window_picker = 1
		vim.g.nvim_tree_icon_padding = " "
		vim.g.nvim_tree_symlink_arrow = ">>"
		vim.g.nvim_tree_respect_buf_cwd = 1
		vim.g.nvim_tree_create_in_closed_folder = 1
		vim.g.nvim_tree_refresh_wait = 500

		vim.g.nvim_tree_icons = {
			default = "",
			symlink = "",
			git = {
				unstaged = "✗",
				staged = "✓",
				unmerged = "",
				renamed = "➜",
				untracked = "★",
				deleted = "",
				ignored = "◌",
			},
			folder = {
				arrow_open = "",
				arrow_closed = "",
				default = "",
				open = "",
				empty = "",
				empty_open = "",
				symlink = "",
				symlink_open = "",
			},
		}

		local tree_cb = require("nvim-tree.config").nvim_tree_callback
		local function cancel() return nil end

		require("nvim-tree").setup({
			disable_netrw = true,
			hijack_netrw = true,
			open_on_setup = false,
			ignore_ft_on_setup = {},
			auto_close = false,
			open_on_tab = false,
			hijack_cursor = false,
			update_cwd = false,
			update_to_buf_dir = { enable = true, auto_open = true },
			git = {

				enable = true,
				ignore = false,
			},
			diagnostics = {
				enable = false,
				icons = { hint = "", info = "", warning = "", error = "" },
			},
			update_focused_file = {
				enable = true,
				update_cwd = false,
				ignore_list = {},
			},
			filters = { dotfiles = false, custom = {} },
			view = {
				width = 40,
				height = 30,
				hide_root_folder = false,
				side = "left",
				auto_resize = false,
				custom_only = true,
				mappings = {
					list = {
						{ key = "<Enter>", cb = tree_cb("cd") },
						{ key = { "<Enter>", "o" }, cb = tree_cb("edit") },
						{ key = "<C-v>", cb = tree_cb("vsplit") },
						{ key = "<C-x>", cb = tree_cb("split") },
						{ key = "<Tab>", cb = tree_cb("preview") },
						{ key = "R", cb = tree_cb("refresh") },
						{ key = "a", cb = tree_cb("create") },
						{ key = "d", cb = tree_cb("remove") },
						{ key = "r", cb = tree_cb("rename") },
						{ key = "x", cb = tree_cb("cut") },
						{ key = "c", cb = tree_cb("copy") },
						{ key = "s", cb = cancel() },
						{ key = "p", cb = tree_cb("paste") },
						{ key = "y", cb = tree_cb("copy_name") },
						{ key = "Y", cb = tree_cb("copy_path") },
						{ key = "gy", cb = tree_cb("copy_absolute_path") },
						{ key = "-", cb = tree_cb("dir_up") },
						{ key = "q", cb = tree_cb("close") },
						{ key = "g?", cb = tree_cb("toggle_help") },
            { key = "s", cb = cancel() }
					},
				},
			},
		})
	end,
}
