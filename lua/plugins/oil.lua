local u = require("functions.utils")

local file

local M = {
	"stevearc/oil.nvim",
	config = function()
		vim.keymap.set("n", "<C-h>", function()
			vim.opt.splitright = false
			vim.cmd.vsplit()
			vim.opt.splitright = true
			local path = vim.fn.expand("%:p")
			local dir = u.dirname(path)
			file = u.basename(path)
			require("oil").open(dir)
		end, merge(global_keymap_opts, { desc = "Open parent directory" }))
		require("oil").setup({
			delete_to_trash = true,
			skip_confirm_for_simple_edits = true,
			keymaps = {
				["g?"] = "actions.show_help",
				["<CR>"] = "actions.select",
				["<C-p>"] = "actions.preview",
				["-"] = "actions.parent",
				["_"] = "actions.open_cwd",
				["`"] = "actions.cd",
				["~"] = "actions.tcd",
				["gs"] = "actions.change_sort",
				["gx"] = "actions.open_external",
				["g."] = "actions.toggle_hidden",
				["<C-c>"] = false,
				["<C-s>"] = false,
				["<C-h>"] = false,
				["<C-t>"] = false,
				["<C-l>"] = false,
				["a"] = {
					desc = "share file with code companion",
					callback = function()
						local Path = require("plenary.path")
						local oil = require("oil")
						local cc = require("codecompanion")
						local fmt = string.format
						local cur_dir = oil.get_current_dir()
						local fullpath = cur_dir .. oil.get_cursor_entry().name
						local path = Path:new(fullpath)
						local _, content = pcall(function()
							return Path.new(fullpath):read()
						end)

						local relpath = path:make_relative()
						local ft = vim.filetype.match({ filename = fullpath })
						local description = fmt(
							[[%s %s:
              ```%s
              %s
              ```]],
							"Here is the content of the file",
							"located at `" .. relpath .. "`",
							ft,
							content
						)
						local id = "<file>" .. relpath .. "</file>"
						cc.last_chat():add_message({
							role = require("codecompanion.config").config.constants.USER_ROLE,
							content = description,
						}, { reference = id, visible = false })

						require("notify")("Sent file to code companion", vim.log.levels.INFO)
					end,
				},
			},
			view_options = {
				show_hidden = true,
				is_always_hidden = function(name)
					return name == ".DS_Store"
				end,
			},
		})
	end,
	dependencies = { "kyazdani42/nvim-web-devicons" },
}

vim.api.nvim_create_autocmd("User", {
	pattern = "OilEnter",
	callback = vim.schedule_wrap(function(args)
		local oil = require("oil")
		if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_cursor_entry() then
			u.jump_to_line(file)
		end
	end),
})

return M
