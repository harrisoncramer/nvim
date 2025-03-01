local M = {}

-- Search for the word under the cursor
M.go_to_word = function(opts)
	opts = opts or {}
	local filetype_option = opts.filetype and ("-t " .. opts.filetype) or ""
	local cmd = string.format(
		"rg -w -o %s --json --line-number --column \"%s\" . | jq -s 'map(select(.data.submatches | length > 0) | .data)'",
		filetype_option,
		opts.word
	)

	local j, err = io.popen(cmd)
	if j == nil then
		require("notify")("Error running command: " .. tostring(err), vim.log.levels.ERROR)
		return
	end

	local json = vim.fn.trim(j:read("*a"))
	if json == "" then
		require("notify")("Word not found", vim.log.levels.ERROR)
		return
	end

	local success, data = pcall(vim.json.decode, json)
	if not success then
		require("notify")("Error decoding JSON: " .. tostring(data), vim.log.levels.ERROR)
		return
	end

	if vim.tbl_isempty(data) then
		require("notify")("Search is empty", vim.log.levels.WARN)
		return
	end

	if #data == 1 then
		local item = data[1]
		vim.cmd("edit " .. item.path.text) -- Open the file specified in the path
		vim.fn.cursor(item.line_number, item.submatches[1].start) -- Move cursor to the line and column
	else
		local qf_list = {}
		for _, item in ipairs(data) do
			table.insert(qf_list, {
				filename = item.path.text,
				lnum = item.line_number,
				col = item.submatches[1].start,
				text = "Match",
			})
		end
		vim.fn.setqflist(qf_list, "r")
		vim.cmd("copen")
	end
end

return M
