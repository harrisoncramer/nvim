local is_open = false
return {
	setup = function(remap)
		remap({ "n", "<leader>;", ":lua require('plugins/nvim_tree').setup_and_open()<CR>" })

		vim.g.nvim_tree_root_folder_modifier = 1
		vim.g.nvim_tree_highlight_opened_files = 0
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
	end,
	setup_and_open = function()
		-- Key mappings
		local list = {
			{ key = "<C-v>", action = "vsplit" },
			{ key = "<C-x>", action = "split" },
			{ key = "<BS>", action = "close_node" },
			{ key = "o", action = "toggle_node" },
			{ key = "<Tab>", action = "preview" },
			{ key = "<Enter>", action = "edit" },
			{ key = "I", action = "toggle_ignored" },
			{ key = "H", action = "toggle_dotfiles" },
			{ key = "R", action = "refresh" },
			{ key = "a", action = "create" },
			{ key = "d", action = "remove" },
			{ key = "D", action = "trash" },
			{ key = "r", action = "rename" },
			{ key = "<C-r>", action = "full_rename" },
			{ key = "x", action = "cut" },
			{ key = "c", action = "copy" },
			{ key = "p", action = "paste" },
			{ key = "y", action = "copy_name" },
			{ key = "Y", action = "copy_path" },
			{ key = "gy", action = "copy_absolute_path" },
			{ key = "-", action = "dir_up" },
			{ key = "q", action = "close" },
			{ key = "g?", action = "toggle_help" },
		}

		if is_open then
			vim.cmd("NvimTreeToggle")
		else
			is_open = true
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
					enable = true,
					icons = { hint = "", info = "", warning = "", error = " " },
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
						custom_only = true,
						list = list,
					},
				},
				trash = {
					cmd = "trash",
					require_confirm = true,
				},
			})
		end
	end,
}
