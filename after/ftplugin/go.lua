local u = require("functions.utils")

local function add_json_tag()
	local line_num = vim.api.nvim_win_get_cursor(0)[1]
	local line = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, false)[1]

	-- Extract the first word (field name)
	local field_name = u.get_first_word()
	if not field_name then
		print("Could not determine field name.")
		return
	end

	-- Convert field name to snake_case
	local json_key = u.pascal_to_snake_case(field_name)

	-- Append JSON tag
	local new_line = line:gsub("%s*$", "") .. string.format(' `json:"%s"`', json_key)

	-- Update line in buffer
	vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, false, { new_line })
end

local function go_to_query()
	local word = u.get_word_under_cursor()

	local cmd = string.format(
		"rg -o -t sql --json --line-number --column \"%s\" . | jq -r 'select(.data.submatches | length > 0)' | jq -r '.data'",
		word
	)
	local j = io.popen(cmd)
	if j == nil then
		require("notify")("No query found", vim.log.levels.ERROR)
		return
	end

	local json = vim.fn.trim(j:read("*a"))
	local success, data = pcall(vim.json.decode, json)
	if not success then
		require("notify")("Error decoding JSON: " .. tostring(data), vim.log.levels.ERROR)
		return
	end

	if
		not data
		or not data.path
		or not data.path.text
		or not data.line_number
		or not data.submatches
		or not data.submatches[1]
		or not data.submatches[1].start
	then
		require("notify")("Invalid data structure in JSON", vim.log.levels.ERROR)
		return
	end

	vim.cmd("edit " .. data.path.text) -- Open the file specified in the path
	vim.fn.cursor(data.line_number, data.submatches[1].start) -- Move cursor to the line and column
end

vim.keymap.set("n", "<localleader>jt", add_json_tag)
vim.keymap.set("n", "gq", go_to_query)
