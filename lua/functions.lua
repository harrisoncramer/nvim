-- Globals
function _G.put(...)
	local objects = {}
	for i = 1, select("#", ...) do
		local v = select(i, ...)
		table.insert(objects, vim.inspect(v))
	end

	print(table.concat(objects, "\n"))
	return ...
end

-- Function Module
local M = {}

M.get_reg = function(char)
	return vim.api.nvim_exec([[echo getreg(']] .. char .. [[')]], true):gsub("[\n\r]", "^J")
end

M.start_replace = function()
	vim.cmd("startreplace")
end

M.getVisualSelection = function()
	local modeInfo = vim.api.nvim_get_mode()
	local mode = modeInfo.mode

	local cursor = vim.api.nvim_win_get_cursor(0)
	local cline, ccol = cursor[1], cursor[2]
	local vline, vcol = vim.fn.line("v"), vim.fn.col("v")

	local sline, scol
	local eline, ecol
	if cline == vline then
		if ccol <= vcol then
			sline, scol = cline, ccol
			eline, ecol = vline, vcol
			scol = scol + 1
		else
			sline, scol = vline, vcol
			eline, ecol = cline, ccol
			ecol = ecol + 1
		end
	elseif cline < vline then
		sline, scol = cline, ccol
		eline, ecol = vline, vcol
		scol = scol + 1
	else
		sline, scol = vline, vcol
		eline, ecol = cline, ccol
		ecol = ecol + 1
	end

	if mode == "V" or mode == "CTRL-V" or mode == "\22" then
		scol = 1
		ecol = nil
	end

	local lines = vim.api.nvim_buf_get_lines(0, sline - 1, eline, 0)
	if #lines == 0 then
		return
	end

	local startText, endText
	if #lines == 1 then
		startText = string.sub(lines[1], scol, ecol)
	else
		startText = string.sub(lines[1], scol)
		endText = string.sub(lines[#lines], 1, ecol)
	end

	local selection = { startText }
	if #lines > 2 then
		vim.list_extend(selection, vim.list_slice(lines, 2, #lines - 1))
	end
	table.insert(selection, endText)

	return selection
end

M.capture = function(cmd, raw)
	local f = assert(io.popen(cmd, "r"))
	local s = assert(f:read("*a"))
	f:close()
	if raw then
		return s
	end
	s = string.gsub(s, "^%s+", "")
	s = string.gsub(s, "%s+$", "")
	s = string.gsub(s, "[\n\r]+", " ")
	return s
end

M.getBufferName = function()
	return vim.fn.expand("%")
end

M.getOS = function()
	return vim.loop.os_uname().sysname
end

local open_url = function(url)
	vim.cmd("exec \"!xdg-open '" .. url .. "'\"")
end

local get_branch_name = function()
	for line in io.popen("git branch 2>nul"):lines() do
		local m = line:match("%* (.+)$")
		if m then
			return m
		end
	end
end

M.get_branch_name = get_branch_name

local file_exists = function(name)
	local f = io.open(name, "r")
	return f ~= nil and io.close(f)
end

M.file_exists = file_exists

M.create_or_source_obsession = function()
	local branch = get_branch_name()
	if branch == nil then
		return
	end
	branch = branch:gsub("%W", "")
	if vim.fn.isdirectory(".sessions") == 1 then
		local session_path = ".sessions/session." .. branch .. ".vim"
		if file_exists(session_path) then
			vim.cmd(string.format("silent source %s", session_path))
			vim.cmd(string.format("silent Obsession %s", session_path))
		else
			vim.cmd(string.format("silent Obsession %s", session_path))
		end
	else
		print("There is no .sessions folder in this project yet!")
	end
end

M.escape_string = function(text)
	return text:gsub("([^%w])", "%%%1")
end

M.shortcut = function()
	local branch = get_branch_name()
	local finalUrl = "https://app.shortcut.com/crossbeam/story"
	branch = get_branch_name() .. "/"

	if not string.find(branch, "sc%-") then
		print("Not a shortcut branch")
		return
	end

	local parts = {}
	for word in string.gmatch(branch, "(.-)/") do
		table.insert(parts, word)
	end
	for i = #parts, 1, -1 do
		finalUrl = finalUrl .. "/" .. parts[i]
	end
	finalUrl = finalUrl:gsub("(sc%-)", "")
	open_url(finalUrl)
end

M.calendar = function()
	open_url("https://calendar.google.com/")
end

local exec_and_return = function(command)
	local f = io.popen(command)

	local l = f:read("*a")

	f:close()

	return l
end

M.exec_and_return = exec_and_return

M.get_project_name = function()
	local git_dir = exec_and_return("git rev-parse --show-toplevel")
	local file_path_split = mysplit(git_dir, "/")
	local project_name = nil
	for k, v in pairs(file_path_split) do
		project_name = v
	end
	return project_name
end

-- Remapping function.
M.remap = function(key)
	local opts = { noremap = true, silent = true }
	for i, v in pairs(key) do
		if type(i) == "string" then
			opts[i] = v
		end
	end
	local buffer = opts.buffer
	opts.buffer = nil
	if buffer then
		vim.api.nvim_buf_set_keymap(0, key[1], key[2], key[3], opts)
	else
		vim.api.nvim_set_keymap(key[1], key[2], key[3], opts)
	end
end

return M
