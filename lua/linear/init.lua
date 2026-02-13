local M = {}

local toolNotes = [[
Tool notes:
- Always use ripgrep when searching files, not find, which is slower
]]

M.select_issue = function()
	local query = [[
{
  issues(filter: { team: { name: { eq: "Engineering" } }, state: { name: { neq: "In Production" } }, assignee: { email: { eq: "harrisonc@givechariot.com" } } }) {
    nodes {
      id
      identifier
      title
      description
      url
      branchName
      priority
      labels {
        nodes {
          name
        }
      }
      project {
        name
      }
      state {
        name
      }
    }
  }
}
]]

	M.call_linear_api(query, function(data)
		if not data.issues then
			vim.notify("Failed to fetch issues from Linear", vim.log.levels.ERROR)
			return
		end

		local issues = data.issues.nodes
		if #issues == 0 then
			vim.notify("No issues found", vim.log.levels.INFO)
			return
		end

		M.show_issue_picker("Search: ", issues, M.process_issue)
	end)
end

M.process_issue = function(issue)
	if issue == nil or issue == "" then
		return
	end

	local cc = require("codecompanion")

	local prompt = string.format(
		[[
You are performing an automated investigation of this Linear issue: %s

If this ticket is a bug, you are trying to provide context that's helpful in solving the bug, and replicating it. This context and hypothesis of the underlying issue(s) will be used by a subsequent step to attempt to replicate it and fix it.

If this ticket is a feature request, you are writing the plan for a subsequent agent to pick up and execute to build the feature.

Your task:
1. Use mcp__linear-server__get_issue with the issue identifier %s to fetch full details
2. Use mcp__linear-server__list_comments to check if there's already a comment starting with "## Claude Enrichment". If so, just exit.
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

%s
]],
		issue,
		issue,
		issue,
		issue,
		toolNotes
	)

	vim.cmd("CodeCompanionChat<cmd>CodeCompanionChat adapter=claude_code Toggle")
	cc.last_chat():add_message({
		role = require("codecompanion.config").config.constants.USER_ROLE,
		content = prompt,
	}, { reference = "<select_issue>", visible = false })
	require("codecompanion").last_chat():submit()
end

M.code = function(issue)
	if issue == nil or issue == "" then
		return
	end

	local cc = require("codecompanion")
	local Path = require("plenary.path")

	local investigation_file = "/tmp/" .. issue .. ".md"
	local p = Path:new(investigation_file)

	if not p:exists() then
		vim.notify("No investigation found for " .. issue .. ". Run select_issue first.", vim.log.levels.ERROR)
		return
	end

	local implementation_file = "/tmp/" .. issue .. "-implementation.md"
	local impl_p = Path:new(implementation_file)

	if impl_p:exists() then
		vim.notify("Issue already implemented: " .. implementation_file, vim.log.levels.INFO)
		return
	end

	local prompt = string.format(
		[[
You are implementing a fix or feature for Linear issue: %s

Your task:
1. Read the investigation report at %s
2. Use mcp__linear-server__get_issue with identifier %s to get full issue details
3. Get the branch name from Linear's API using the branchName field from the issue
4. Make sure you have the latest code from staging by fetching it to the root worktree. Then check out that branch, off of that latest staging code, in this worktree.
5. Implement the fix or feature based on the investigation and action plan
6. Stage all changes: git add .
7. Commit using commitizen: cz commit (follow the interactive prompts)
8. Push the branch: git push -u origin <branchName>
9. Create a draft PR: gh pr create --draft --title "<issue>: <title>" --body "<summary>"
10. Write an implementation summary to %s
11. Use mcp__linear-server__create_comment to post a brief summary (three, maybe four short, punchy sentences) with the changes made, be short but descriptive.

Implementation summary format:

## Implementation Summary

Brief explanation of the implementation. Couple of sentences max.

### Notes
Any concerns, limitations, or follow-up work needed. Couple of sentences max.

---
*Automated implementation by Claude Code*

Guidelines:
- Follow existing code patterns and conventions
- Write tests if they exist for similar functionality
- Keep commits atomic and well-described
- If you encounter errors, document them in the implementation summary
- The PR body should include a link to the Linear issue
%s
]],
		issue,
		investigation_file,
		issue,
		implementation_file,
		toolNotes
	)

	vim.cmd("CodeCompanionChat<cmd>CodeCompanionChat adapter=claude_code Toggle")
	cc.last_chat():add_message({
		role = require("codecompanion.config").config.constants.USER_ROLE,
		content = prompt,
	}, { reference = "<implement_issue>", visible = false })
	require("codecompanion").last_chat():submit()
end

M.show_issue_picker = function(prompt, issues, on_select)
	local issue_items = {}
	for _, issue_data in ipairs(issues) do
		local labels = {}
		if type(issue_data.labels) == "table" and type(issue_data.labels.nodes) == "table" then
			for _, label in ipairs(issue_data.labels.nodes) do
				table.insert(labels, label.name)
			end
		end

		local project_name = "None"
		if type(issue_data.project) == "table" and issue_data.project.name then
			project_name = issue_data.project.name
		end

		local state_name = "Unknown"
		if type(issue_data.state) == "table" and issue_data.state.name then
			state_name = issue_data.state.name
		end

		table.insert(issue_items, {
			text = issue_data.identifier .. ": " .. issue_data.title,
			identifier = issue_data.identifier,
			description = type(issue_data.description) == "string" and issue_data.description or "No description",
			url = type(issue_data.url) == "string" and issue_data.url or "",
			branchName = type(issue_data.branchName) == "string" and issue_data.branchName or "",
			priority = type(issue_data.priority) == "string" and issue_data.priority or "None",
			labels = labels,
			project = project_name,
			state = state_name,
		})
	end

	require("snacks").picker.pick({
		prompt = prompt,
		items = issue_items,
		format = function(item)
			return { { item.text, "Normal" } }
		end,
		preview = function(ctx)
			local lines = {}

			table.insert(lines, "## Properties")
			table.insert(lines, "")
			table.insert(lines, "**Project:** " .. ctx.item.project)
			table.insert(lines, "**State:** " .. ctx.item.state)
			table.insert(lines, "**Priority:** " .. ctx.item.priority)
			if #ctx.item.labels > 0 then
				table.insert(lines, "**Labels:** " .. table.concat(ctx.item.labels, ", "))
			end
			if ctx.item.branchName ~= "" then
				table.insert(lines, "**Branch:** " .. ctx.item.branchName)
			end
			table.insert(lines, "")
			table.insert(lines, "## Description")
			table.insert(lines, "")

			local desc = ctx.item.description or "No description"
			for _, line in ipairs(vim.split(desc, "\n")) do
				table.insert(lines, line)
			end

			ctx.preview:set_lines(lines)
			ctx.preview:wo({ wrap = true, linebreak = true })
			ctx.preview:highlight({ ft = "markdown" })
		end,
		actions = {
			open_in_linear = function(picker)
				local item = picker.list:current()
				if item and item.url then
					vim.fn.jobstart({ "open", "-a", "/Applications/Linear.app", item.url }, { detach = true })
				end
			end,
			copy_branch = function(picker)
				local item = picker.list:current()
				if item and item.branchName and item.branchName ~= "" then
					vim.fn.setreg("+", item.branchName)
					vim.notify("Copied branch: " .. item.branchName, vim.log.levels.INFO)
				else
					vim.notify("No branch name available", vim.log.levels.WARN)
				end
			end,
			run = function(picker)
				local item = picker.list:current()
				if item then
					on_select(item.identifier)
				end
			end,
		},
		confirm = function(item)
			M.code(item.identifier)
		end,
		win = {
			preview = {
				keys = {
					["<C-e>"] = { "open_in_linear", mode = { "n" } },
					["<C-g>"] = { "copy_branch", mode = { "n" } },
					["<C-r>"] = { "run", mode = { "n" } },
				},
			},
			list = {
				keys = {
					["<C-e>"] = { "open_in_linear", mode = { "n" } },
					["<C-g>"] = { "copy_branch", mode = { "n" } },
					["<C-r>"] = { "run", mode = { "n" } },
				},
			},
			input = {
				keys = {
					["<C-e>"] = { "open_in_linear", mode = { "n", "i" } },
					["<C-g>"] = { "copy_branch", mode = { "n", "i" } },
					["<C-r>"] = { "run", mode = { "n", "i" } },
				},
			},
		},
	})
end

M.call_linear_api = function(query, on_success, on_error)
	local api_key = os.getenv("LINEAR_API_KEY")
	if not api_key then
		vim.notify("LINEAR_API_KEY not set", vim.log.levels.ERROR)
		return
	end

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

			if not ok or not parsed.data then
				if on_error then
					on_error("Failed to parse response from Linear")
				else
					vim.notify("Failed to fetch data from Linear", vim.log.levels.ERROR)
				end
				return
			end

			if on_success then
				on_success(parsed.data)
			end
		end,
		on_stderr = function(_, data)
			if data and #data > 0 and data[1] ~= "" then
				local error_msg = table.concat(data, "\n")
				if on_error then
					on_error(error_msg)
				end
			end
		end,
	})
end

vim.keymap.set(
	"n",
	"<C-l>",
	M.select_issue,
	vim.tbl_extend("force", global_keymap_opts, { desc = "Select Linear issue" })
)

return M
