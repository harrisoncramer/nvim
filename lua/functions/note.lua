local M = {}

vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })

M.open_floating_window = function()
	local file_path = "~/.config/nvim/notes.md"

	-- Create a new buffer for the file
	local buf = vim.fn.bufnr(file_path, true) -- Get buffer number or create if not exists
	if buf == -1 then
		buf = vim.api.nvim_create_buf(true, false) -- Create a new buffer
		vim.api.nvim_buf_set_name(buf, file_path) -- Set buffer name
	end

	-- Set up floating window dimensions
	local width = vim.o.columns
	local height = vim.o.lines
	local win_width = math.ceil(width * 0.8)
	local win_height = math.ceil(height * 0.6)
	local row = math.ceil((height - win_height) / 2) - 1
	local col = math.ceil((width - win_width) / 2)

	-- Create floating window
	local opts = {
		style = "minimal",
		relative = "editor",
		width = win_width,
		height = win_height,
		row = row,
		col = col,
		border = "rounded",
	}

	vim.api.nvim_open_win(buf, true, opts)

	vim.api.nvim_buf_set_keymap(0, "n", "<C-y>", ":bd<CR>", { noremap = true, silent = true })

	-- Open the file in the buffer
	vim.cmd("silent! e " .. file_path)
end

return M
