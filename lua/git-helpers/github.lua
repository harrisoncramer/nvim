local M = {}

-- Define a function to post a comment to GitHub
M.post_comment_to_github = function(pr_number, line_number, comment_body, file_path)
	local commit_id =
		vim.fn.system({ "gh", "pr", "view", "--json", "commits", "--jq", ".commits[-1].oid" }):gsub("%s+", "")
	if vim.v.shell_error ~= 0 then
		require("notify")("Error: Unable to retrieve commit hash")
		return nil
	end

	local side = M.is_current_sha_focused() and "RIGHT" or "LEFT"
	local comment_data = vim.json.encode({
		body = comment_body,
		commit_id = commit_id,
		path = file_path,
		line = line_number,
		side = side,
	})

	local curl_cmd = string.format(
		'curl -X POST -H "Authorization: token %s" '
			.. "-d '%s' "
			.. "https://api.github.com/repos/chariot-giving/chariot/pulls/%d/comments",
		os.getenv("GITHUB_TOKEN"),
		comment_data,
		pr_number
	)

	-- Execute the curl command
	local output = vim.fn.system(curl_cmd)

	local exit_code = vim.v.shell_error
	if exit_code ~= 0 then
		require("notify")("Error sending comment", vim.log.levels.ERROR)
		require("notify")(output, vim.log.levels.ERROR)
	else
		require("notify")("Comment posted successfully!")
	end
end

-- Function called to submit the comment
M.submit_comment = function(pr_number, line_number, file_path)
	local buf = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	local comment_body = table.concat(lines, "\n")
	vim.api.nvim_win_close(0, true) -- Close the popup
	M.post_comment_to_github(pr_number, line_number, comment_body, file_path)
end

-- Define a function to display a popup and capture input
M.open_comment_popup = function()
	-- Get the line number and PR number. Stub, replace with actual implementation.
	local pr_number = vim.fn.system("gh pr view --json number --jq '.number'")
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local line_number = cursor_pos[1]
	local file_path = M.get_file_path_in_reviewer()

	local buf = vim.api.nvim_create_buf(false, true)
	local width, height = 60, 10
	local opts = {
		relative = "cursor",
		width = width,
		height = height,
		col = 1, -- Shift slightly to the right of the cursor
		row = 0, -- Keep it aligned with the cursor row
		anchor = "NW", -- Anchor the window to the top-left of the cursor
		style = "minimal",
		border = "single", -- Optional: Adds a visible border
	}

	local _ = vim.api.nvim_open_win(buf, true, opts)

	vim.keymap.set("n", "<leader>S", function()
		M.submit_comment(pr_number, line_number, file_path)
	end, { noremap = true, silent = true, buffer = vim.api.nvim_get_current_buf() })

	-- Auto-close the float-buffer on leaving it
	vim.api.nvim_create_autocmd("BufLeave", { buffer = buf, command = "bwipeout!" })
end

M.open_blame_in_github = function()
	local gitsigns = require("gitsigns")
	gitsigns.blame_line({ full = false }, function()
		gitsigns.blame_line({}, function()
			local commit = vim.fn.getline(1):match("^(%x+)")
			vim.cmd(":quit")
			vim.fn.system(string.format("gh browse %s", commit))
		end)
	end)
end

vim.keymap.set(
	"n",
	"<leader>gB",
	M.open_blame_in_github,
	merge(global_keymap_opts, { desc = "Given the current line, opens up the commit in Github that made the change" })
)

vim.keymap.set("n", "<leader>gC", function()
	M.open_comment_popup()
end, merge(global_keymap_opts, { desc = "Open comment popup" }))

return M
