local u = require("functions.utils")

local M = {}

-- Reads the lines from a file into the quickfix list
---@param filepath string
---@param prefix? string
M.read_file_to_qf = function(filepath, prefix)
	local quickfix_list = {}

	local lines = u.read_lines_from_file(filepath)

	for _, line in ipairs(lines) do
		if line:match("^[^:]+:%d+:") then
			local file, lnum, col, text = line:match("(.+):(%d+):(%d+): (.+)")
			if file and lnum and col and text then
				file = (prefix or "") .. file
				table.insert(quickfix_list, {
					filename = file,
					lnum = tonumber(lnum),
					col = tonumber(col),
					text = text,
				})
			end
		end
	end

	vim.fn.setqflist(quickfix_list, "r")
	vim.cmd("copen")
end

return M
