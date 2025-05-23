-- Loads a file located in .qf into the quickfix list in Neovim.
local function load_quickfix_from_file()
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

return {
	load_quickfix_from_file = load_quickfix_from_file,
}
