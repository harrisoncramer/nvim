local M = {}

-- Track the currently loaded quickfix file
local current_qf_file = nil
local qf_change_timer = nil

local read_quickfix_files = function()
	vim.fn.mkdir(".qf", "p")
	local qf_dir = vim.fn.expand(".qf/")

	local handle = io.popen("ls " .. qf_dir)
	if not handle then
		vim.notify("Failed to read .qf/ directory", vim.log.levels.ERROR)
		return
	end

	local file_name_results = handle:read("*a")
	handle:close()

	local all_files = {}
	for v in file_name_results:gmatch("[^\r\n]+") do
		local filepath = ".qf/" .. v
		local stat = vim.loop.fs_stat(filepath)
		table.insert(all_files, {
			title = v,
			text = v,
			file = filepath,
			mtime = stat and stat.mtime.sec or 0,
		})
	end

	table.sort(all_files, function(a, b)
		return a.mtime > b.mtime
	end)

	return all_files
end

-- Remove current quickfix item and re-save file
M.remove_current_qf_item = function()
	if not current_qf_file then
		require("notify")("No quickfix file currently loaded", vim.log.levels.WARN)
		return
	end

	local current_line = vim.fn.line(".")
	local qflist = vim.fn.getqflist()

	if current_line > #qflist or current_line < 1 then
		require("notify")("Invalid quickfix line", vim.log.levels.WARN)
		return
	end

	table.remove(qflist, current_line)
	vim.fn.setqflist({}, "r", { items = qflist })

	if M.save_qf_to_file(current_qf_file, qflist) then
		vim.fn.fnamemodify(current_qf_file, ":t")
	end

	if current_line <= #qflist and current_line > 1 then
		vim.fn.cursor(current_line, 1)
	elseif #qflist > 0 then
		vim.fn.cursor(math.min(current_line, #qflist), 1)
	end
end

-- Prompts to select a file located in .qf, which loads it into the quickfix list in Neovim.
M.manage_quickfix_list = function()
	local pickerFunctions = require("plugins.snacks.functions")

	local all_files = read_quickfix_files()
	if #all_files == 0 then
		require("notify")("No quickfix entries found.", vim.log.levels.ERROR)
		return
	end

	local keys = {
		["<CR>"] = { "load", mode = { "n", "i" } },
		["<C-d>"] = { "delete", mode = { "n", "i" } },
	}

	require("snacks").picker.pick({
		title = "Load Saved Quickfix List",
		items = all_files,
		preview = "file",
		format = "file",
		formatters = {
			file = {
				filename_only = true,
			},
		},
		actions = {
			delete = function(picker, choice)
				local success, msg = os.remove(choice.file)
				if not success then
					require("notify")(msg, vim.log.levels.ERROR)
				else
					if current_qf_file == choice.file then
						current_qf_file = nil
					end
					picker:close()
				end
			end,
			load = function(_, choice)
				local file_handle = io.open(choice.file)
				if not file_handle then
					vim.notify("Failed to read file " .. choice, vim.log.levels.ERROR)
					return
				end

				local lines = {}
				for line in file_handle:lines() do
					local path, lnum, col, text = line:match("([^:]+):(%d+):(%d+):%s*(.+)")
					if path and lnum and col and text then
						table.insert(lines, {
							filename = path,
							lnum = tonumber(lnum),
							col = tonumber(col),
							text = text,
						})
					end
				end

				file_handle:close()

				if #lines > 0 then
					vim.fn.setqflist({}, " ", { title = choice.text, items = lines })
					vim.cmd("copen")
					-- Track which file is currently loaded
					current_qf_file = choice.file
				else
					vim.notify("No valid quickfix entries found in file", vim.log.levels.WARN)
				end
			end,
		},
		win = {
			preview = {
				keys = merge(pickerFunctions.preview_keys, keys),
			},
			list = {
				keys = merge(pickerFunctions.list_keys, keys),
			},
			input = {
				keys = merge(pickerFunctions.input_keys, keys),
			},
		},
	})
end

-- Saves the current quickfix into a file in .qf (keep existing manual save)
M.save_quickfix_to_file = function()
	vim.cmd.cclose()
	vim.ui.input({ prompt = "Enter file name: " }, function(filename)
		if filename == nil or filename == "" then
			return
		end
		filename = string.lower(string.gsub(filename, "%s+", "_"))
		vim.fn.mkdir(".qf", "p")
		local filepath = ".qf/" .. filename
		local file = io.open(filepath, "w")
		if file == nil then
			require("notify")("Error creating file", vim.log.levels.ERROR)
			return
		end

		local qfListLines = vim.fn.getqflist()
		for _, item in ipairs(qfListLines) do
			local entry_file_name
			if item.filename and item.filename ~= "" then
				entry_file_name = item.filename
			elseif item.user_data and item.user_data.lsp and item.user_data.lsp.item then
				local uri = item.user_data.lsp.item.uri
				if uri then
					entry_file_name = vim.uri_to_fname(uri)
				end
			elseif item.bufnr and item.bufnr > 0 then
				local path = vim.api.nvim_buf_get_name(item.bufnr)
				if path and path ~= "" then
					entry_file_name = path
				end
			end

			local current_dir = vim.fn.getcwd()
			entry_file_name = (entry_file_name or "[No file]"):gsub("^file://", ""):gsub(current_dir .. "/", "")

			local line = string.format("%s:%d:%d: %s", entry_file_name, item.lnum or 0, item.col or 0, item.text or "")
			file:write(line .. "\n")
		end

		file:close()

		-- Track the saved file
		current_qf_file = filepath
	end)
end

M.send_file_to_codecompanion = function()
	local cc = require("codecompanion")
	local last_chat = cc.last_chat()

	if not last_chat then
		require("notify")("No active CodeCompanion chat session. Please start a chat first.", vim.log.levels.WARN)
		return
	end
	local qflist = vim.fn.getqflist()
	local current_line = vim.fn.line(".")

	if current_line > #qflist then
		require("notify")("No quickfix entry at current line", vim.log.levels.WARN)
		return
	end

	local item = qflist[current_line]
	local filename

	if item.filename and item.filename ~= "" then
		filename = item.filename
	elseif item.user_data and item.user_data.lsp and item.user_data.lsp.item then
		local uri = item.user_data.lsp.item.uri
		if uri then
			filename = vim.uri_to_fname(uri)
		end
	elseif item.bufnr and item.bufnr > 0 then
		local path = vim.api.nvim_buf_get_name(item.bufnr)
		if path and path ~= "" then
			filename = path
		end
	end

	if not filename or filename == "" then
		require("notify")("Could not determine filename for current quickfix entry", vim.log.levels.ERROR)
		return
	end

	filename = filename:gsub("^file://", "")

	local Path = require("plenary.path")
	local path = Path:new(filename)
	local success, content = pcall(function()
		return path:read()
	end)

	if not success then
		require("notify")("Failed to read file: " .. filename, vim.log.levels.ERROR)
		return
	end

	local relpath = path:make_relative()
	local ft = vim.filetype.match({ filename = filename })
	local description = string.format(
		[[%s %s:
```%s
%s
```]],
		"Here is the content of the file",
		"located at `" .. relpath .. "`",
		ft or "",
		content
	)

	local id = "<file>" .. relpath .. "</file>"
	cc.last_chat():add_message({
		role = require("codecompanion.config").config.constants.USER_ROLE,
		content = description,
	}, { reference = id, visible = false })

	require("notify")("Sent file to CodeCompanion: " .. relpath, vim.log.levels.INFO)
end

M.toggle_qf = function()
	local ft = vim.bo.filetype
	if ft == "qf" then
		vim.cmd.cclose()
	else
		vim.cmd.copen()
	end
end

M._set_current_file = function(filepath)
	current_qf_file = filepath
end

M.save_qf_to_file = function(filepath, qflist)
	local file = io.open(filepath, "w")
	if not file then
		require("notify")("Failed to update quickfix file", vim.log.levels.ERROR)
		return false
	end

	for _, item in ipairs(qflist) do
		local entry_file_name
		if item.filename and item.filename ~= "" then
			entry_file_name = item.filename
		elseif item.user_data and item.user_data.lsp and item.user_data.lsp.item then
			local uri = item.user_data.lsp.item.uri
			if uri then
				entry_file_name = vim.uri_to_fname(uri)
			end
		elseif item.bufnr and item.bufnr > 0 then
			local path = vim.api.nvim_buf_get_name(item.bufnr)
			if path and path ~= "" then
				entry_file_name = path
			end
		end

		local current_dir = vim.fn.getcwd()
		entry_file_name = (entry_file_name or "[No file]"):gsub("^file://", ""):gsub(current_dir .. "/", "")

		local line = string.format("%s:%d:%d: %s", entry_file_name, item.lnum or 0, item.col or 0, item.text or "")
		file:write(line .. "\n")
	end

	file:close()
	return true
end

M.handle_qf_change = function()
	if not current_qf_file then
		return
	end

	if qf_change_timer then
		qf_change_timer:stop()
	end

	qf_change_timer = vim.defer_fn(function()
		local qflist = vim.fn.getqflist()
		if #qflist > 0 then
			if M.save_qf_to_file(current_qf_file, qflist) then
				vim.fn.fnamemodify(current_qf_file, ":t")
			end
		end
		qf_change_timer = nil
	end, 100)
end

return M
