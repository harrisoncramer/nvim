-- Globals
function _G.P(...)
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

M.start_replace = function()
	vim.cmd("startreplace")
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

local getBufferName = function()
	return vim.fn.expand("%")
end

M.getBufferName = getBufferName

M.get_os = function()
	return vim.loop.os_uname().sysname
end

M.currentDir = function()
	return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
end

M.is_diff_mode = function()
	return vim.api.nvim_win_get_option(0, "diff")
end

local open_url = function(url)
	vim.cmd("exec \"!xdg-open '" .. url .. "'\"")
end

local get_branch_name = function()
	local is_git_branch = io.popen("git rev-parse --is-inside-work-tree 2>/dev/null"):read("*a")
	if is_git_branch == "true\n" then
		for line in io.popen("git branch 2>/dev/null"):lines() do
			local m = line:match("%* (.+)$")
			if m then
				return m
			end
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
	local args = vim.v.argv
	if #args ~= 1 then
		return nil
	end
	local branch = get_branch_name()
	if not branch then
		branch = "init_branch_session"
	else
		branch = branch:gsub("%W", "")
	end
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

local split = function(str, delimiter)
	local result = {}
	for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
		table.insert(result, match)
	end
	return result
end

M.split = split

local reload = function(package_name)
	local t = split(package_name, " ")
	for _, value in ipairs(t) do
		package.loaded[value] = nil
		local status = pcall(require, value)
		if not status then
			print(value .. " is not available.")
		end
	end
end

M.reload = reload

M.reload_current = function()
	local current_buffer = getBufferName()
	local module_name = split(current_buffer, "/lua")
	local patterns = { "/", ".lua" }
	for _, value in ipairs(patterns) do
		module_name = string.gsub(current_buffer, value, "")
	end
	reload(module_name)
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

M.run_script = function(script_name)
	local nvim_scripts_dir = "~/.config/nvim/scripts"
	local f = io.popen(string.format("/bin/bash %1s/%2s", nvim_scripts_dir, script_name))
	local l = f:read("*a")
	f:close()
	return l
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
