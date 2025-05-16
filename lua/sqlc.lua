local sqlc_namespace = vim.api.nvim_create_namespace("sqlc")

---Helper function to parse the output of sqlc vet and create diagnostics
---@param output string
---@return vim.Diagnostic
local function parse_sqlc_output(output)
	local diagnostics = {}
	for line in output:gmatch("[^\r\n]+") do
		local filename, lnum, col, message = line:match("^(.-):(%d+):(%d+): (.+)$")
		if filename and lnum and col and message then
			table.insert(diagnostics, {
				filename = filename,
				lnum = tonumber(lnum) - 1, -- Convert to 0-based index
				col = tonumber(col) - 1, -- Convert to 0-based index
				message = message,
				severity = vim.diagnostic.severity.ERROR,
			})
		end
	end
	return diagnostics
end

---Function to run the vet command and update diagnostics
---@return string
local function run_sqlc_against_current_file()
	local config_file = "sqlc.yaml"
	local current_dir = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
	local file_name = vim.fs.basename(vim.api.nvim_buf_get_name(0))
	local command = "SQLC_DATABASE_URI=postgresql://chariot:samplepassword@0.0.0.0:5432/chariot?connect_timeout=300 sqlc vet -f "
		.. current_dir
		.. "/"
		.. config_file
		.. " "
		.. current_dir
		.. "/"
		.. file_name

	local output = vim.fn.system(command)
	return output
end

---Function to clear diagnostics in the current buffer
local clear_diagnostics = function()
	vim.diagnostic.reset(sqlc_namespace, 0)
end

--- Function to set diagnostics in the current buffer
---@return nil
local function set_diagnostics()
	clear_diagnostics()
	local output = run_sqlc_against_current_file()
	if output == "" then
		return
	end
	local diagnostics = parse_sqlc_output(output)

	-- Set new diagnostics
	for _, diagnostic in ipairs(diagnostics) do
		vim.diagnostic.set(sqlc_namespace, 0, {
			{
				lnum = diagnostic.lnum,
				col = diagnostic.col,
				severity = vim.diagnostic.severity.ERROR,
				message = diagnostic.message,
			},
		})
	end
end

-- Create an autocommand to call the above function on save
vim.api.nvim_create_autocmd({ "BufWritePost", "InsertEnter" }, {
	pattern = "*.sql",
	callback = function(args)
		if args.event == "BufWritePost" then
			set_diagnostics()
		elseif args.event == "InsertEnter" then
			clear_diagnostics()
		end
	end,
})

return {
	sqlc_namespace,
}
