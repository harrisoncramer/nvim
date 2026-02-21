-- File browser plugin that lets you edit your filesystem like a buffer
local u = require("functions.utils")

-- Tracks the filename to restore cursor position when opening oil
local file

local M = {
	"stevearc/oil.nvim",
	config = function()
		-- Open oil in a left vertical split showing the current file's directory
		vim.keymap.set("n", "<C-h>", function()
			M.original_win = vim.api.nvim_get_current_win() -- Store window to replace later
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
				["<Enter>"] = {
					desc = "Select file and replace current split",
					callback = function()
						local oil = require("oil")
						local entry = oil.get_cursor_entry()
						if not entry then
							return
						end

						if entry.type == "directory" then
							require("oil").select()
							return
						end
						local dir = oil.get_current_dir()
						local filepath = dir .. entry.name

						-- Close oil split and open file in original window
						if M.original_win and vim.api.nvim_win_is_valid(M.original_win) and vim.fn.winnr("$") > 1 then
							vim.cmd("close")
							vim.api.nvim_set_current_win(M.original_win)
							vim.cmd("edit " .. vim.fn.fnameescape(filepath))
							M.original_win = nil
						else
							-- Otherwise, just open the buffer
							vim.cmd("edit " .. vim.fn.fnameescape(filepath))
							M.original_win = nil
						end
					end,
				},
				["g?"] = "actions.show_help",
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
					-- Send the file under cursor to the active CodeCompanion chat session
					callback = function()
						local cc = require("codecompanion")
						local last_chat = cc.last_chat()

						if not last_chat then
							require("notify")(
								"No active CodeCompanion chat session. Please start a chat first.",
								vim.log.levels.WARN
							)
							return
						end

						local Path = require("plenary.path")
						local oil = require("oil")
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

-- When oil opens, jump to the line of the file that was open before
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
