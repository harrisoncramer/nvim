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

	return false
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
