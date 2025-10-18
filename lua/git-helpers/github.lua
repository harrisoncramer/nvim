local M = {}

-- Use GitHub CLI to search for PR containing this commit
M.open_pr_from_hash = function(hash)
	local cmd =
		string.format('gh pr list --search "%s" --state all --limit 1 --json url --jq ".[0].url // empty"', hash)

	vim.fn.jobstart(cmd, {
		stdout_buffered = true,
		on_stdout = function(_, data)
			local pr_url = table.concat(data, ""):gsub("%s+", "")

			if pr_url == "" or pr_url == "null" then
				vim.notify("No PR found for commit " .. hash, vim.log.levels.WARN)
				return
			end
			vim.fn.jobstart({ "open", pr_url }, { detach = true })
		end,
	})
end

return M
