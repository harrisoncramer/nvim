local queries = require("functions.debug.queries")

local M = {
	total_lines = 0,
}

-- Setup command for easy access
vim.api.nvim_create_user_command("DEBUG", function()
	M.toggle()
end, { nargs = 0 })

-- Removes previously added print statements
M.clear_debug_statements = function()
	vim.cmd("silent g/DEBUG_/d")
	vim.cmd("silent w")
	M.total_lines = 0
end

-- Function to insert a print statement at a given line
M.insert_print_statement = function(line, name)
	local msg = string.format('fmt.Println("%s")', name)
	vim.api.nvim_buf_set_lines(0, line, line, false, { msg })
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

	local bufnr = vim.api.nvim_get_current_buf()
	local Path = require("plenary").path
	local filename = Path:new(vim.fn.expand("%")):make_relative()

	M.debug_methods(root, bufnr, filename)
	M.debug_functions(root, bufnr, filename)
	vim.cmd("silent w")
end

M.debug_methods = function(root, bufnr, filename)
	local q = queries.get()
	local nodes = {}
	for _, node, _, _ in q.method_query:iter_captures(root, bufnr) do
		if node:type() == "block" then
			local start_row, _, _, _ = node:range()
			table.insert(nodes, { node = node, start_row = start_row })
		end
	end

	-- Step 2: Insert print statements, updating offsets dynamically
	local offset = 0
	for i, entry in ipairs(nodes) do
		local start_row = entry.start_row + offset -- Adjust for previous insertions
		M.insert_print_statement(start_row + 1, M.prepare_log_content(filename, start_row + 1, "FUNCTION", i))
		offset = offset + 1 -- Increase offset after insertion
	end
end

M.debug_functions = function(root, bufnr, filename)
	local q = queries.get()
	local nodes = {}
	for _, node, _, _ in q.function_query:iter_captures(root, bufnr) do
		if node:type() == "block" then
			local start_row, _, _, _ = node:range()
			table.insert(nodes, { node = node, start_row = start_row })
		end
	end

	-- Step 2: Insert print statements, updating offsets dynamically
	local offset = 0
	for i, entry in ipairs(nodes) do
		local start_row = entry.start_row + offset -- Adjust for previous insertions
		M.insert_print_statement(start_row + 1, M.prepare_log_content(filename, start_row + 1, "METHOD", i))
		offset = offset + 1 -- Increase offset after insertion
	end
end

M.prepare_log_content = function(filename, new_line_number, type, log_number)
	return string.format("%s:%s [DEBUG_%s_%s]", filename, new_line_number + 1, type, log_number)
end

M.get_or_create_buffers = function(file_paths)
	local buffers = {}
	for _, file in ipairs(file_paths) do
		local buf = vim.fn.bufnr(file)
		if buf == -1 then
			vim.cmd("edit " .. vim.fn.fnameescape(file))
			buf = vim.fn.bufnr(file)
		end
		table.insert(buffers, buf)
	end
	return buffers
end

return M

-- M.debugged_buffers = {}
-- vim.api.nvim_create_user_command("DEBUGMANY", function()
-- TODO: Maybe implement this?
-- require("plugins.snacks.functions").git_files({
-- 	extra_keys = { ["<CR>"] = { "print", mode = { "n", "i" } } },
-- 	actions = {
-- 		print = function(res)
-- 			local paths = {}
-- 			for _, val in ipairs(res.list.selected) do
-- 				table.insert(paths, val._path)
-- 			end
-- 			local buffer_numbers = M.get_or_create_buffers(paths)
-- 		end,
-- 	},
-- })
-- end, { nargs = 0 })
