return {
	setup = function()
		local function get_git_head()
			local head = vim.call("FugitiveHead")
			if head == "" or head == nil then
				return "DETATCHED "
			end
			if string.len(head) > 20 then
				head = ".." .. head:sub(15)
			end
			return " " .. head
		end

		local function get_time()
			return os.date("%I:%M:%S", os.time()):gsub("^0", "")
		end

		require("lualine").setup({
			options = {
				component_separators = { right = "" },
				section_separators = { left = "", right = "" },
				-- theme = 'gruvbox-material'
			},
			sections = {
				lualine_a = { get_git_head },
				lualine_b = { "diff", "diagnostics" },
				lualine_c = { "vim.fn.expand('%')" },
				lualine_d = {},
				lualine_w = { "filetype" },
				lualine_x = {
					{
						"tabs",
						mode = 0,
						tabs_color = {
							active = { bg = "285474" },
						},
					},
				},
				lualine_y = { get_time },
				lualine_z = {},
			},
		})

		vim.cmd([[
  au BufEnter,BufWinEnter,WinEnter,CmdwinEnter * if bufname('%') == "NvimTree" | set laststatus=0 | else | set laststatus=2 | endif
  ]])

		if _G.Statusline_timer == nil then
			_G.Statusline_timer = vim.loop.new_timer()
		else
			_G.Statusline_timer:stop()
		end
		_G.Statusline_timer:start(
			0,
			1000,
			vim.schedule_wrap(function()
				vim.api.nvim_command("redrawstatus")
			end)
		)
	end,
}
