local M = {}

M.note_pos = { 1, 0 }
M.buf_pos = nil
M.win_id = nil

M.toggle_floating_window = function()
	if M.win_id ~= nil then
		M.note_pos = vim.api.nvim_win_get_cursor(M.win_id)
		M.win_id = nil
		vim.cmd("bd")
		vim.api.nvim_win_set_cursor(0, M.buf_pos)
		return
	end

	M.buf_pos = vim.api.nvim_win_get_cursor(0)

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

	local win_id = vim.api.nvim_open_win(buf, true, opts)
	M.win_id = win_id

	-- Open the file in the buffer
	vim.cmd("silent! e " .. file_path)
	vim.cmd("set wrap")
	vim.api.nvim_win_set_cursor(0, M.note_pos)
end

return M
