local M = {}

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
		table.insert(all_files, {
			title = v,
			text = v,
			file = filepath,
		})
	end

	return all_files
end

-- Prompts to select a file located in .qf, which loads it into the quickfix list in Neovim.
M.manage_quickfix_list = function()
	local pickerFunctions = require("plugins.snacks.functions")

	local all_files = read_quickfix_files()

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
					require("notify")("Deleted " .. choice.text .. " quickfix entry!")
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
					vim.fn.setqflist({}, " ", { title = choice, items = lines })
					vim.cmd("copen")
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

-- Saves the current quickfix into a file in .qf
M.save_quickfix_to_file = function()
	vim.cmd.cclose()
	vim.ui.input({ prompt = "Enter file name: " }, function(filename)
		if filename == nil or filename == "" then
			return
		end
		filename = string.lower(string.gsub(filename, "%s+", "_"))
		vim.fn.mkdir(".qf", "p")
		local file = io.open(".qf/" .. filename .. ".txt", "w")
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

		require("notify")("Saved quickfix entry!")
	end)
end

return M
