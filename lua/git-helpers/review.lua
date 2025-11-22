local M = {}

-- Get diff of current feature branch and create a diff file, then give that file to Code Companion.
M.review_changes = function(branch)
	local Path = require("plenary.path")
	local cc = require("codecompanion")
	local diff_file = vim.fn.tempname() .. ".diff"

	local exclusions = {
		"':(exclude)*go.mod'",
		"':(exclude)*go.sum'",
		"':(exclude)**/db/models/**'",
		"':(exclude)**/jet/**'",
	}

	local git_cmd =
		string.format("git diff origin/%s..HEAD -- %s > %s", branch, table.concat(exclusions, " "), diff_file)

	local result = vim.fn.system(git_cmd)
	local exit_code = vim.v.shell_error

	if exit_code ~= 0 then
		vim.notify("Error creating diff: " .. result, vim.log.levels.ERROR)
		return
	end

	local diff_content = vim.fn.readfile(diff_file)
	if #diff_content == 0 then
		vim.notify("No changes found between origin/main and HEAD", vim.log.levels.WARN)
		return
	end

	vim.defer_fn(function()
		local path = Path:new(diff_file)
		local success, content = pcall(function()
			return path:read()
		end)

		if not success then
			vim.notify("Error reading diff file: " .. content, vim.log.levels.ERROR)
			return
		end

		local pr_info = ""
		local gh_result = vim.fn.system("gh pr view --json title,body 2>/dev/null")
		local gh_exit_code = vim.v.shell_error

		if gh_exit_code == 0 then
			local ok, pr_data = pcall(vim.fn.json_decode, gh_result)
			if ok and pr_data then
				local title = pr_data.title or "No title"
				local body = pr_data.body or "No description"
				pr_info = string.format("\n### PR Information:\n**Title:** %s\n**Description:**\n%s\n", title, body)
			end
		else
			pr_info = "\n### PR Information:\nNo PR found or GitHub CLI not available.\n"
		end

		local lines = string.format(
			[[Please review the following code changes and provide feedback on:
			  - Potential bugs or issues.
        - Performance considerations.
        - Maintainability and readability.

        You do not have to stick to these specific sections, for instance if there are no performance considerations to consider just don't mention them in your chat.

        Please be precise with your feedback, referencing specific line numbers in the code whenever you make a suggestion. Do not mention theoreticals or poential problems, but be grounded in actual problems. Also, be brief if there is nothing obviously wrong.
        Here is the diff:
      %s
      %s
      ]],
			pr_info,
			content
		)

		local relpath = path:make_relative()
		local id = "<file>" .. relpath .. "</file>"

		vim.cmd("CodeCompanionChat Toggle")
		cc.last_chat():add_message({
			role = require("codecompanion.config").config.constants.USER_ROLE,
			content = lines,
		}, { reference = id, visible = false })
		require("codecompanion").last_chat():submit()
	end, 100)
end

return M
