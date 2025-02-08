local M = {}

M.send_failures_to_qf = function()
	local diagnostics = vim.diagnostic.get(nil) -- Get diagnostics for all buffers
	local qf_list = {}

	for _, d in ipairs(diagnostics) do
		if d.severity == vim.diagnostic.severity.ERROR then
			local bufname = vim.api.nvim_buf_get_name(d.bufnr)
			if bufname ~= "" then
				table.insert(qf_list, {
					filename = bufname,
					lnum = d.lnum + 1, -- Convert to 1-based index
					col = d.col + 1, -- Convert to 1-based index
					text = d.message,
				})
			end
		end
	end

	if #qf_list > 0 then
		vim.fn.setqflist(qf_list, "r")
		vim.cmd("copen") -- Open the quickfix list
	else
		vim.notify("No failures found", vim.log.levels.INFO)
	end
end
return M
