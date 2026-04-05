-- These are non-language specific autocommands
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
	end,
	desc = "Highlights the yanked text",
})

-- Taken from: https://stackoverflow.com/questions/4292733/vim-creating-parent-directories-on-save
vim.cmd([[
  function s:MkNonExDir(file, buf)
      if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
          let dir=fnamemodify(a:file, ':h')
          if !isdirectory(dir)
              call mkdir(dir, 'p')
          endif
      endif
  endfunction
  augroup BWCCreateDir
      autocmd!
      autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
  augroup END
]])

local augroups = {}

local cursor_pos
augroups.yankpost = {
	save_cursor_position = {
		event = { "VimEnter", "CursorMoved" },
		pattern = "*",
		callback = function()
			cursor_pos = vim.fn.getpos(".")
		end,
	},
	highlight_yank = {
		event = "TextYankPost",
		pattern = "*",
		callback = function()
			vim.highlight.on_yank({ higroup = "IncSearch", timeout = 400, on_visual = true })
		end,
	},
	yank_restore_cursor = {
		event = "TextYankPost",
		pattern = "*",
		callback = function()
			if vim.v.event.operator == "y" then
				vim.fn.setpos(".", cursor_pos)
			end
		end,
	},
}

for group, commands in pairs(augroups) do
	local augroup = vim.api.nvim_create_augroup("AU_" .. group, { clear = true })

	for _, opts in pairs(commands) do
		local event = opts.event
		opts.event = nil
		opts.group = augroup
		vim.api.nvim_create_autocmd(event, opts)
	end
end

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
	pattern = "*",
	command = "checktime",
	desc = "Reload files changed outside of neovim",
})

vim.api.nvim_create_autocmd("FocusGained", {
	pattern = "*",
	callback = function()
		local sock = vim.v.servername
		if sock and sock ~= "" then
			local f = io.open("/tmp/nvim-active-sock", "w")
			if f then
				f:write(sock)
				f:close()
			end
		end
	end,
	desc = "Track active neovim instance socket",
})

-- Basic session management!
vim.api.nvim_create_autocmd("VimLeavePre", {
	command = "mksession! /tmp/.nvim_session.vim",
})

-- Keybinding to restore session
vim.api.nvim_set_keymap("n", "<leader>S", ":source /tmp/.nvim_session.vim<CR>", { noremap = true, silent = true })
