local M = {}

-- the FOLLOW commands runs the watch script, which sets a service name into a temporary file
-- and then watches logs for any failures. These failures will update the tmux header so that we
-- can see them right away, and can be picked up by get_build_failures command below, which runs
-- the failures script
vim.api.nvim_create_user_command("FOLLOW", function(opts)
	local result = vim.fn.system(string.format("watch %s", opts.args))
	if vim.v.shell_error ~= 0 then
		require("notify")(string.format("Could not follow '%s' container: ", opts.args) .. result, vim.log.levels.ERROR)
	end
end, { nargs = 1 })

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
	local svc = M.get_current_service()
	if svc == nil then
		require("notify")("No service being monitored", vim.log.levels.ERROR)
		return
	end

	vim.fn.setqflist({}, "r")
	vim.cmd(string.format("cd /Users/harrisoncramer/chariot/chariot/apps/%s", svc))
	vim.api.nvim_set_current_dir(string.format("/Users/harrisoncramer/chariot/chariot/apps/%s", svc))
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
