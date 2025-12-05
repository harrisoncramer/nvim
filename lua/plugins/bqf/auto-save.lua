local M = {}

-- Helper function to sanitize search query for filename
local function sanitize_filename(str)
	if not str or str == "" then
		return "quickfix_" .. os.time()
	end

	local sanitized = str:gsub("[^%w%s%-_]", "") -- Keep only alphanumeric, spaces, hyphens, underscores
	sanitized = sanitized:gsub("%s+", "_") -- Replace spaces with underscores
	sanitized = sanitized:gsub("_+", "_") -- Collapse multiple underscores
	sanitized = sanitized:gsub("^_", "") -- Remove leading underscore
	sanitized = sanitized:gsub("_$", "") -- Remove trailing underscore

	return sanitized:lower()
end

-- Auto-save quickfix with search query as filename
M.auto_save_quickfix = function(search_query)
	local qfListLines = vim.fn.getqflist()
	if #qfListLines == 0 then
		return
	end

	vim.fn.mkdir(".qf", "p")
	local filename_base = sanitize_filename(search_query)
	local filename = ".qf/" .. filename_base

	-- Handle duplicates by adding a counter
	local counter = 1
	local final_filename = filename
	while vim.fn.filereadable(final_filename) == 1 do
		final_filename = filename .. "_" .. counter
		counter = counter + 1
	end

	local file = io.open(final_filename, "w")
	if file == nil then
		require("notify")("Error auto-saving quickfix", vim.log.levels.ERROR)
		return
	end

	for _, item in ipairs(qfListLines) do
		local entry_file_name
		if item.filename and item.filename ~= "" then
			entry_file_name = item.filename
		elseif item.user_data and item.user_data.lsp and item.user_data.lsp.item then
			local uri = item.user_data.lsp.item.uri
			if uri then
				entry_file_name = vim.uri_to_fname(uri)
			end
		elseif item.bufnr and item.bufnr > 0 then
			local path = vim.api.nvim_buf_get_name(item.bufnr)
			if path and path ~= "" then
				entry_file_name = path
			end
		end

		local current_dir = vim.fn.getcwd()
		entry_file_name = (entry_file_name or "[No file]"):gsub("^file://", ""):gsub(current_dir .. "/", "")

		local line = string.format("%s:%d:%d: %s", entry_file_name, item.lnum or 0, item.col or 0, item.text or "")
		file:write(line .. "\n")
	end

	file:close()

	-- Set the current file for tracking
	local quickfix = require("plugins.bqf.quickfix")
	if quickfix then
		quickfix._set_current_file(final_filename)
	end
end

return M
