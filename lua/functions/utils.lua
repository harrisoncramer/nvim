-- These are functions that are used within the Lua configuration and
-- are not meant for export to the end user.
return {
	get_os = function()
		return vim.loop.os_uname().sysname
	end,
	get_register = function(char)
		return vim.api.nvim_exec([[echo getreg(']] .. char .. [[')]], true):gsub("[\n\r]", "^J")
	end,
	get_visual_selection = function()
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
	end,
	get_buffer_name = function()
		return vim.fn.expand("%")
	end,
	split = function(str, delimiter)
		local result = {}
		for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
			table.insert(result, match)
		end
		return result
	end,
	current_dir = function()
		return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
	end,
	open_url = function(url)
		vim.cmd("exec \"!xdg-open '" .. url .. "'\"")
	end,
	get_branch_name = function()
		local is_git_branch = io.popen("git rev-parse --is-inside-work-tree 2>/dev/null"):read("*a")
		if is_git_branch == "true\n" then
			for line in io.popen("git branch 2>/dev/null"):lines() do
				local m = line:match("%* (.+)$")
				if m then
					return m
				end
			end
		end
	end,
	file_exists = function(name)
		local f = io.open(name, "r")
		return f ~= nil and io.close(f)
	end,
	escape_string = function(text)
		return text:gsub("([^%w])", "%%%1")
	end,
	remap = function(key)
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
	end,
}
