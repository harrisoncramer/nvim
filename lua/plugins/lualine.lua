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

-- local function get_time()
-- 	return os.date("%I:%M:%S", os.time()):gsub("^0", "")
-- end

require("lualine").setup({
	options = {
		component_separators = { right = "" },
		section_separators = { left = "", right = "" },
		theme = "kanagawa",
	},
	sections = {
		lualine_a = { get_git_head },
		lualine_b = { "diff", "diagnostics" },
		lualine_c = {
			{
				"filetype",
				colored = true, -- Displays filetype icon in color if set to true
				icon_only = true, -- Display only an icon for filetype
			},
			{
				"filename",
				file_status = true,
				path = 1,
				symbols = {
					modified = "  ", -- Text to show when the file is modified.
					readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
					unnamed = "[No Name]", -- Text to show for unnamed buffers.
				},
			},
		},
		lualine_d = {},
		lualine_w = {},
		lualine_x = {},
		lualine_y = {},
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
-- Don't immediately redraw the screen
_G.Statusline_timer:start(
	10000,
	1000,
	vim.schedule_wrap(function()
		vim.api.nvim_command("redrawstatus")
	end)
)
