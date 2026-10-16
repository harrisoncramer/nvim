local u = require("functions.utils")
local M = {}

M.get_current_service = function()
	local file = io.open("/tmp/current_service", "r")
	if file == nil then
		return nil
	end
	local svc = file:read("*all"):gsub("%s+", "")
	if svc ~= nil then
		return svc
	end
	return nil
end

-- get_build_failures runs the 'failures' script which returns to us a list of failures
-- formatted in a way like  ./main.go:160:2: undefined: appGET
-- We then parse out the file name and line number, and set it in the quickfix list
M.get_build_failures = function()
	if not u.ensure_executable("failures") then
		return
	end
	local svc = M.get_current_service()
	if svc == nil then
		require("notify")("No service being monitored", vim.log.levels.ERROR)
		return
	end

	vim.fn.setqflist({}, "r")
	local svc_dir = string.format("%s/chariot/chariot/apps/%s", vim.env.HOME, svc)
	vim.cmd("cd " .. svc_dir)
	vim.api.nvim_set_current_dir(svc_dir)
	local failures = vim.fn.systemlist(string.format("failures %s", svc))

	local qf_list = {}

	for _, line in ipairs(failures) do
		local file, lnum, col, message = line:match("(.-):(%d+):(%d+): (.+)")
		if file and lnum and col and message then
			table.insert(qf_list, {
				filename = file,
				lnum = tonumber(lnum),
				col = tonumber(col),
				text = message,
			})
		end
	end

	if #qf_list > 0 then
		vim.fn.setqflist(qf_list, "r")
		vim.cmd("copen") -- Open quickfix list
	else
		vim.notify("No failures found", vim.log.levels.INFO)
	end
end

return M
