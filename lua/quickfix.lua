local M = {}

-- Loads a file located in .qf into the quickfix list in Neovim.
M.load_quickfix_from_file = function()
	vim.fn.mkdir(".qf", "p")
	local qf_dir = vim.fn.expand(".qf/")

	local handle = io.popen("ls " .. qf_dir)
	if not handle then
		vim.notify("Failed to read .qf/ directory", vim.log.levels.ERROR)
		return
	end

	local result = handle:read("*a")
	handle:close()

	local all_files = {}
	for filename in result:gmatch("[^\r\n]+") do
		table.insert(all_files, filename)
	end

	vim.ui.select(all_files, {
		prompt = "Choose File",
	}, function(choice)
		if choice == nil then
			return
		end

		local filepath = qf_dir .. choice
		local lines = {}
		for line in io.lines(filepath) do
			local path, lnum, col, text = line:match("([^:]+):(%d+):(%d+):%s*(.+)")
			if path and lnum and col and text then
				table.insert(lines, {
					filename = path,
					lnum = tonumber(lnum),
					col = tonumber(col),
					text = text,
				})
			end
		end

		if #lines > 0 then
			vim.fn.setqflist({}, " ", { title = choice, items = lines })
			vim.cmd("copen")
		else
			vim.notify("No valid quickfix entries found in file", vim.log.levels.WARN)
		end
	end)
end

-- Saves the current quickfix into a file in .qf
M.save_quickfix_to_file = function()
	vim.cmd.cclose()
	vim.ui.input({ prompt = "Enter file name: " }, function(filename)
		if filename == nil or filename == "" then
			return
		end
		vim.fn.mkdir(".qf", "p")
		local file = io.open(".qf/" .. filename, "w")
		if file == nil then
			require("notify")("Error creating file", vim.log.levels.ERROR)
			return
		end

		local qfListLines = vim.fn.getqflist()
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

			entry_file_name = (entry_file_name or "[No file]"):gsub("^file://", "")
			local line = string.format("%s:%d:%d: %s", entry_file_name, item.lnum or 0, item.col or 0, item.text or "")
			file:write(line .. "\n")
		end

		file:close()

		require("notify")("Saved quickfix entry!")
	end)
end

-- Deletes a file from the .qf directory
M.delete_quickfix_entry = function()
	vim.fn.mkdir(".qf", "p")
	local qf_dir = vim.fn.expand(".qf/")

	local handle = io.popen("ls " .. qf_dir)
	if not handle then
		vim.notify("Failed to read .qf/ directory", vim.log.levels.ERROR)
		return
	end

	local result = handle:read("*a")
	handle:close()

	local all_files = {}
	for filename in result:gmatch("[^\r\n]+") do
		table.insert(all_files, filename)
	end

	vim.ui.select(all_files, {
		prompt = "Choose File",
	}, function(choice)
		if choice == nil then
			return
		end

		local success, msg = os.remove(".qf/" .. choice)
		if not success then
			require("notify")(msg, vim.log.levels.ERROR)
		else
			require("notify")("Deleted quickfix entry!")
		end
	end)
end

return M
