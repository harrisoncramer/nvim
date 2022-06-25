local u = require("functions.utils")

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

-- These are functions that could theoretically be called by the user
-- although they are generally used by other commands (in the commands.lua file)
-- or are used by mappings (in the mappings folder)

return {
	capture = function(cmd, raw)
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
	end,
	start_replace = function()
		vim.cmd("startreplace")
	end,
	reload = function(package_name)
		local t = u.split(package_name, " ")
		for _, value in ipairs(t) do
			package.loaded[value] = nil
			local status = pcall(require, value)
			if not status then
				print(value .. " is not available.")
			end
		end
	end,
	reload_current = function()
		local current_buffer = u.get_buffer_name()
		local module_name = u.split(current_buffer, "/lua")
		local patterns = { "/", ".lua" }
		for _, value in ipairs(patterns) do
			module_name = string.gsub(current_buffer, value, "")
		end
		package.loaded[module_name] = nil
		local status = pcall(require, module_name)
		if not status then
			print(module_name .. " is not available.")
		end
	end,
	shortcut = function()
		local branch = u.get_branch_name()
		local finalUrl = "https://app.shortcut.com/crossbeam/story"
		branch = u.get_branch_name() .. "/"

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
		u.open_url(finalUrl)
	end,
	calendar = function()
		u.open_url("https://calendar.google.com/")
	end,
	create_or_source_obsession = function()
		local args = vim.v.argv
		if #args ~= 1 then
			return nil
		end
		local branch = u.get_branch_name()
		if not branch then
			branch = "init_branch_session"
		else
			branch = branch:gsub("%W", "")
		end
		if vim.fn.isdirectory(".sessions") == 1 then
			local session_path = ".sessions/session." .. branch .. ".vim"
			if u.file_exists(session_path) then
				vim.cmd(string.format("silent source %s", session_path))
				vim.cmd(string.format("silent Obsession %s", session_path))
			else
				vim.cmd(string.format("silent Obsession %s", session_path))
			end
		else
			print("There is no .sessions folder in this project yet!")
		end
	end,
	run_script = function(script_name, args)
		local nvim_scripts_dir = "~/.config/nvim/scripts"
		local f = nil
		if args == nil then
			f = io.popen(string.format("/bin/bash %1s/%2s", nvim_scripts_dir, script_name))
		else
			f = io.popen(string.format("/bin/bash %1s/%2s %3s", nvim_scripts_dir, script_name, args))
		end
		local output = f:read("*a")
		f:close()
		return output
	end,
	share_screen = function(is_sharing)
		vim.cmd("set relativenumber!")
		if is_sharing then
			vim.cmd("colorscheme kanagawa")
		else
			vim.cmd("colorscheme codedark")
		end
		require("functions").run_script("share_screen", is_sharing)
	end,
	stash = function(name)
		vim.fn.system("git stash -u -m " .. name)
	end,
}
