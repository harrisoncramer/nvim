local M = {}

M.enrich_issue = function()
	local api_key = os.getenv("LINEAR_API_KEY")
	if not api_key then
		vim.notify("LINEAR_API_KEY not set", vim.log.levels.ERROR)
		return
	end

	local query = [[
{
  issues(filter: { labels: { name: { eq: "Claude" } } }) {
    nodes {
      id
      identifier
      title
      description
    }
  }
}
]]

	local curl_cmd = string.format(
		[[curl -s -X POST https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: %s" \
  -d '{"query": "%s"}']],
		api_key,
		query:gsub("\n", "\\n"):gsub('"', '\\"')
	)

	vim.fn.jobstart(curl_cmd, {
		stdout_buffered = true,
		on_stdout = function(_, data)
			if not data or #data == 0 then
				return
			end

			local response = table.concat(data, "\n")
			local ok, parsed = pcall(vim.json.decode, response)

			if not ok or not parsed.data or not parsed.data.issues then
				vim.notify("Failed to fetch issues from Linear", vim.log.levels.ERROR)
				return
			end

			local issues = parsed.data.issues.nodes
			if #issues == 0 then
				vim.notify("No issues found with 'Claude' label", vim.log.levels.INFO)
				return
			end

			local issue_list = {}
			for _, issue_data in ipairs(issues) do
				table.insert(issue_list, issue_data.identifier .. ": " .. issue_data.title)
			end

			vim.ui.select(issue_list, {
				prompt = "Select issue to enrich:",
			}, function(selected, idx)
				if not selected then
					return
				end

				local issue = issues[idx].identifier
				M.process_issue(issue)
			end)
		end,
		on_stderr = function(_, data)
			if data and #data > 0 then
				vim.notify("Error fetching issues: " .. table.concat(data, "\n"), vim.log.levels.ERROR)
			end
		end,
	})
end

M.process_issue = function(issue)
	if issue == nil or issue == "" then
		return
	end

	local cc = require("codecompanion")
	local Path = require("plenary.path")

	local prompt = string.format(
		[[
You are performing an automated investigation of this Linear issue: %s

If this ticket is a bug, you are trying to provide context that's helpful in solving the bug, and replicating it. This context and hypothesis of the underlying issue(s) will be used by a subsequent step to attempt to replicate it and fix it.

If this ticket is a feature request, you are writing the plan for a subsequent agent to pick up and execute to build the feature.

Your task:
1. Use mcp__linear-server__get_issue with the issue identifier %s to fetch full details
2. If it's already been enriched, there will be a file at /tmp/%s.md. If so, just exit.
3. Do the enrichment:
   a. Analyze the issue description and title
   b. Search the codebase for relevant code using Glob and Grep
   c. Read relevant files using mcp__acp__Read to understand the context
   d. Create an investigation report
   e. Write the temp file to /tmp/%s.md
   f. Use mcp__linear-server__create_comment to post a shortened summary of this findings file.

## Claude Enrichment

### Related Codepaths or Files

- `path/to/file.ts:123` 
- `path/to/file.ts:123` 
- `path/to/other.go:456`

### (If bug) Possible Causes

What you believe may be causing the issue. Give your most likely cause, and how confident you are, two to three sentences. Then list other possible causes, no more than 1 sentence each.

### (If feature) Action Plan

A detailed plan for the next agent to use to implement the feature.

---
*Automated investigation by Claude Code*

Guidelines:
- READ-ONLY operations only - do not modify files or execute code
- For frontend issues: check components, pages, and API endpoints
- For backend issues: check service handlers, SQLC queries, gRPC definitions
- Include file:line_number references in your findings
- Keep investigations concise but thorough
- Focus on actionable information
]],
		issue,
		issue,
		issue,
		issue
	)

	local tmp_file = "/tmp/" .. issue .. ".md"
	local p = Path:new(tmp_file)

	if p:exists() then
		vim.notify("Issue already enriched: " .. tmp_file, vim.log.levels.INFO)
		return
	end

	vim.cmd("CodeCompanionChat<cmd>CodeCompanionChat adapter=claude_code Toggle")
	cc.last_chat():add_message({
		role = require("codecompanion.config").config.constants.USER_ROLE,
		content = prompt,
	}, { reference = "<enrich_issue_review>", visible = false })
	require("codecompanion").last_chat():submit()
end

return M
