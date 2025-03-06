local queries = require("functions.debug.queries")

local M = {}

-- Removes previously added print statements
M.clear_debug_statements = function()
	vim.cmd("silent g/DEBUG_/d")
	vim.cmd("silent w")
end

-- Function to insert a print statement at a given line
local function insert_print_statement(line, name)
	local msg = string.format('fmt.Println("%s")', name)
	vim.api.nvim_buf_set_lines(0, line, line, false, { msg })
	vim.cmd("silent w")
end

M.prepare_traversal = function()
	local buf = vim.api.nvim_get_current_buf()

	-- If we've already debugged this buffer then remove statements
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	for _, line in ipairs(lines) do
		if line:find("DEBUG_") then
			M.clear_debug_statements()
			return
		end
	end

	local ft = "go" -- vim.bo.filetype
	local ts_parsers = require("nvim-treesitter.parsers")
	local parser = ts_parsers.get_parser(buf, ft)

	if not parser then
		vim.notify(string.format("Could not get %s parser", ft), vim.log.levels.ERROR)
		return
	end

	local tree = parser:parse()
	if not tree or not tree[1] then
		vim.notify("Could not parse tree", vim.log.levels.ERROR)
		return
	end

	local root = tree[1]:root()
	return root
end

-- Traverse the function and insert print statements
M.toggle = function()
	local root = M.prepare_traversal()
	if root == nil then
		return
	end

	local q = queries.get()
	local buf = vim.api.nvim_get_current_buf()

	local Path = require("plenary").path
	local filename = Path:new(vim.fn.expand("%")):make_relative()

	local incrementer = 0
	for id, node, _, _ in q.function_query:iter_captures(root, buf) do
		local type = node:type()
		if type == "block" then
			local starting_row, _, _, _ = node:range() -- range of the capture
			insert_print_statement(starting_row + 1 + incrementer, M.prepare_log_content(filename, incrementer + 1))
			incrementer = incrementer + 1
		end
	end

	for id, node, _, _ in q.method_query:iter_captures(root, buf) do
		local type = node:type()
		if type == "block" then
			local starting_row, _, _, _ = node:range() -- range of the capture
			insert_print_statement(starting_row + incrementer, M.prepare_log_content(filename, incrementer + 1))
			incrementer = incrementer + 1
		end
	end
end

M.prepare_log_content = function(filename, count)
	return string.format("%s: DEBUG_%s", filename, count)
end

return M
