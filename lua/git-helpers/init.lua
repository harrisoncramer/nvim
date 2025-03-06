local M = {}
local map_opts = { noremap = true, silent = true, nowait = true }
local u = require("functions.utils")
local popup = require("popup")

local gitsigns_ok, gitsigns = pcall(require, "gitsigns")
local diffview_ok, diffview = pcall(require, "diffview")
local plenary_ok, job = pcall(require, "plenary.job")

if not gitsigns_ok or not diffview_ok or not plenary_ok then
	vim.api.nvim_err_writeln("Gitsigns, diffview, or plenary not installed, cannot configure Git tools")
	return
end

-- Hunk-level operations
vim.keymap.set("n", "<leader>ghn", function() -- Next Change
	gitsigns.next_hunk()
	gitsigns.preview_hunk()
end)
vim.keymap.set("n", "<leader>ghp", function() -- Next Change
	gitsigns.prev_hunk()
	gitsigns.preview_hunk()
end)
vim.keymap.set("n", "<leader>ghr", gitsigns.reset_hunk) -- Reset Hunk
vim.keymap.set("n", "<leader>gha", gitsigns.stage_hunk) -- Add hunk
vim.keymap.set("n", "<leader>ghv", gitsigns.preview_hunk)

-- View current changes
vim.keymap.set("n", "<leader>gd", function()
	vim.cmd("DiffviewOpen")
end)

-- Adding files...
vim.keymap.set("n", "<leader>gaa", function()
	M.add_all()
end, map_opts)
vim.keymap.set("n", "<leader>gah", gitsigns.stage_hunk)
vim.keymap.set("n", "<leader>gac", function()
	M.add_current()
end, map_opts)

-- Committing changes...
vim.keymap.set("n", "<leader>gcm", function()
	M.commit()
end, map_opts)
vim.keymap.set("n", "<leader>gce", function()
	M.commit_easy()
end, map_opts)

vim.keymap.set("n", "<leader>gC", function()
	M.open_comment_popup()
end, map_opts)

-- Resetting changes...
vim.keymap.set("n", "<leader>gre", function()
	M.reset_easy_commits()
end, map_opts)
vim.keymap.set("n", "<leader>grr", function()
	M.reset()
end, map_opts)

-- Initiate squash since branching from staging
vim.keymap.set("n", "<leader>gS", function()
	vim.ui.input({ prompt = "Enter branch/tag to compare against: " }, function(branch)
		if branch == nil or branch == "" then
			require("notify")("No branch entered!", vim.log.levels.ERROR)
			return
		end
		local j = io.popen("git merge-base origin/" .. branch .. " HEAD")
		if j == nil then
			require("notify")("No commit hash found since staging!", vim.log.levels.ERROR)
			return
		end

		local non_easy_hash = vim.fn.trim(j:read("*a"))
		vim.cmd("Git rebase -i " .. non_easy_hash)
	end)
end, map_opts)

-- Viewing changes and diffs...
vim.keymap.set("n", "<leader>gvc", function()
	M.view_changes()
end, map_opts)
vim.keymap.set("n", "<leader>gvs", function()
	M.view_staged()
end, map_opts)
vim.keymap.set("n", "<leader>gvfh", function()
	M.view_file_history()
end, map_opts)

-- Conflicts
vim.keymap.set("n", "<leader>gxx", function()
	M.resolve_conflict()
end, map_opts)

-- Miscellaneous...
vim.keymap.set("n", "<leader>gb", gitsigns.blame_line)

-- Quickfix
vim.keymap.set("n", "<leader>gqf", function()
	-- Sends all changed files versus staging to the quickfix list
	vim.ui.input({ prompt = "Enter branch/tag to get changed files against: " }, function(branch)
		if branch == nil or branch == "" then
			require("notify")("No branch entered!", vim.log.levels.ERROR)
			return
		end
		local files = vim.fn.system({ "git", "diff", "--name-only", branch })
		local lines = vim.split(files, "\n", { trimempty = true })
		local qf_list = {}
		for _, file in ipairs(lines) do
			table.insert(qf_list, { filename = file })
		end
		vim.fn.setqflist(qf_list, "r")
	end)
end)

vim.keymap.set("n", "<leader>gqq", function()
	gitsigns.setqflist("all") -- Send current changes to the quickfix list
end)

-- Pushing and pulling...
vim.keymap.set("n", "<leader>gPP", function()
	M.push()
end, map_opts)
vim.keymap.set("n", "<leader>gPU", function()
	M.pull()
end, map_opts)

-- Get the file path relative to the git root
M.copy_relative_git_path = function()
	local buf_path = vim.api.nvim_buf_get_name(0)
	local git_root = M.get_root_git_dir()
	local relative_path = buf_path:sub(#git_root + 1)
	return relative_path
end

-- Commits the changes in a file quickly with a message "Updated %s"
M.commit_easy = function()
	local relative_file_path = M.copy_relative_git_path()
	local git_root = M.get_root_git_dir()
	job:new({
		command = "git",
		args = { "commit", relative_file_path, "-m", string.format("Updated %s", relative_file_path) },
		cwd = git_root,
		on_exit = vim.schedule_wrap(function(val, exit_code)
			if exit_code ~= 0 then
				require("notify")("Could not commit change!", vim.log.levels.ERROR)
				require("notify")(val)
				return
			else
				require("notify")("Committed file", vim.log.levels.INFO)
			end
		end),
	}):start()
end

-- Stashes all uncommitted changes in the current branch (git stash)
M.stash = function()
	job:new({
		command = "git",
		args = { "stash" },
		on_exit = vim.schedule_wrap(function(_, exit_code)
			if exit_code ~= 0 then
				require("notify")("Could not stash changes!", vim.log.levels.ERROR)
				return
			else
				require("notify")("Stashed", vim.log.levels.INFO)
			end
		end),
	}):start()
end

-- Stages all changes (git add .)
M.add_all = function()
	job:new({
		command = "git",
		args = { "add", "." },
		on_exit = vim.schedule_wrap(function(_, exit_code)
			if exit_code ~= 0 then
				require("notify")("Could not add all files!", vim.log.levels.ERROR)
				return
			else
				require("notify")("Added all files", vim.log.levels.INFO)
			end
		end),
	}):start()
end

-- Unstages all changes (git reset)
M.reset = function()
	job:new({
		command = "git",
		args = { "reset" },
		on_exit = vim.schedule_wrap(function(_, exit_code)
			if exit_code ~= 0 then
				require("notify")("Could not reset staged changes", vim.log.levels.ERROR)
				return
			else
				require("notify")("Unstaged all changes", vim.log.levels.INFO)
			end
		end),
	}):start()
end

-- Stages current file (git add FILENAME)
M.add_current = function()
	local relative_file_path = u.copy_relative_filepath(true)
	job:new({
		command = "git",
		args = { "add", relative_file_path },
		on_exit = vim.schedule_wrap(function(_, exit_code)
			if exit_code ~= 0 then
				require("notify")(string.format("Could not add %s!", relative_file_path), vim.log.levels.ERROR)
				return
			else
				require("notify")("Added current file", vim.log.levels.INFO)
			end
		end),
	}):start()
end

-- Resets all recent easy commits softly, used in combination with add_all() and commit() to squash
-- easy commits into readable commit message
M.reset_easy_commits = function()
	local latest_non_easy_commit =
		io.popen('git log --format="%s %H" | grep -v "^Updated " | awk \'{ print $NF }\' | tail -n +1 | head -1')
	if latest_non_easy_commit == nil then
		require("notify")("No easy commit hash found!", vim.log.levels.ERROR)
		return
	end

	local non_easy_hash = vim.fn.trim(latest_non_easy_commit:read("*a"))
	latest_non_easy_commit:close()

	job:new({
		command = "git",
		args = { "reset", "--soft", non_easy_hash },
		on_exit = vim.schedule_wrap(function(_, exit_code)
			if exit_code ~= 0 then
				require("notify")("Could not reset easy commits softly!", vim.log.levels.ERROR)
				return
			else
				require("notify")("Soft reset all easy commits", vim.log.levels.INFO)
			end
		end),
	}):start()
end

-- Opens a popup in order to write a commit message
M.commit = function()
	popup.create_popup_with_action("Commit Message", function(msg)
		job:new({
			command = "git",
			args = { "commit", "-m", msg },
			on_exit = vim.schedule_wrap(function(_, exit_code)
				if exit_code ~= 0 then
					require("notify")("Could not commit changes with message!", vim.log.levels.ERROR)
					return
				else
					require("notify")("Committed.", vim.log.levels.INFO)
				end
			end),
		}):start()
	end)
end

-- Pops stashed changes (git stash pop)
M.pop = function()
	job:new({
		command = "git",
		args = { "stash", "pop" },
		on_exit = vim.schedule_wrap(function(_, exit_code)
			if exit_code ~= 0 then
				require("notify")("Could not pop off stash!", vim.log.levels.ERROR)
				return
			else
				require("notify")("Popped.", vim.log.levels.INFO)
			end
		end),
	}):start()
end

-- Push changes (git push)
M.push = function()
	local push_job = job:new({
		command = "git",
		args = { "push" },
		on_exit = function(_, exit_code)
			if exit_code ~= 0 then
				require("notify")("Could not push!", "error")
				return
			else
				require("notify")("Pushed.", "info")
			end
		end,
	})

	local isSubmodule = vim.fn.trim(vim.fn.system("git rev-parse --show-superproject-working-tree"))
	if isSubmodule == "" then
		push_job:start()
	else
		vim.fn.confirm("Push to origin/main branch for submodule?")
		push_job:start()
	end
end

-- Pull changes from remote (git pull)
M.pull = function()
	local pull_job = job:new({
		command = "git",
		args = { "pull" },
		on_exit = function(_, exit_code)
			if exit_code ~= 0 then
				require("notify")("Could not pull!", "error")
				return
			else
				require("notify")("Pulled.", "info")
			end
		end,
	})

	pull_job:start()
end

M.is_inside_work_tree = function(cb)
	local branch_name_job = job:new({
		command = "git",
		args = { "rev-parse", "--is-inside-work-tree" },
		on_stdout = vim.schedule_wrap(function(err, data)
			if err == nil and data == "true" then
				cb()
			end
		end),
	})

	branch_name_job:start()
end

M.is_feature_branch = function(cb)
	local branch_name_job = job:new({
		command = "git",
		args = { "branch", "--show-current" },
		on_stdout = vim.schedule_wrap(function(err, branch_name)
			if err == nil and branch_name ~= nil then
				if branch_name ~= "main" and branch_name ~= "master" then
					cb(branch_name)
				end
			end
		end),
	})

	branch_name_job:start()
end

M.get_root_git_dir = function()
	local cur_path = vim.fn.expand("%:p")
	local dir = vim.fs.find(".git", {
		path = cur_path,
		upward = true,
		type = "directory",
	})[1]
	if dir == nil then
		return dir
	end
	return dir:sub(1, -5)
end

M.branch_exists = function(b)
	local is_git_branch = io.popen("git rev-parse --is-inside-work-tree 2>/dev/null"):read("*a")
	if is_git_branch == "true\n" then
		for line in io.popen("git branch 2>/dev/null"):lines() do
			line = line:gsub("%s+", "")
			if line == b then
				return true
			end
		end
	end
	return false
end

-- Toggle file history of this file
M.view_file_history = function()
	local isDiff = vim.fn.getwinvar(nil, "&diff")
	local bufName = vim.api.nvim_buf_get_name(0)
	diffview.FOCUSED_HISTORY_FILE = bufName
	if isDiff ~= 0 or u.string_starts(bufName, "diff") then
		diffview.FOCUSED_HISTORY_FILE = nil
		vim.cmd.bd()
		vim.cmd.tabprev()
	else
		vim.api.nvim_feedkeys(":DiffviewFileHistory " .. vim.fn.expand("%"), "n", false)
		u.press_enter()
	end
end

-- Toggle viewing all unstaged changes (current diff)
M.view_changes = function()
	local isDiff = vim.fn.getwinvar(0, "&diff")
	local bufName = vim.api.nvim_buf_get_name(0)
	if isDiff ~= 0 or u.string_starts(bufName, "diff") then
		vim.cmd.bd()
		vim.cmd.tabprev()
	else
		vim.cmd("DiffviewOpen")
		u.press_enter()
	end
end

-- Toggle viewing all uncommitted changes (current diff)
M.view_staged = function()
	local isDiff = vim.fn.getwinvar(0, "&diff")
	local bufName = vim.api.nvim_buf_get_name(0)
	if isDiff ~= 0 or u.string_starts(bufName, "diff") then
		vim.cmd.bd()
		vim.cmd.tabprev()
	else
		vim.cmd("DiffviewOpen --staged")
		u.press_enter()
	end
end

M.get_remote_url = function(cb)
	local branch_name_job = job:new({
		command = "git",
		args = { "remote", "get-url", "origin" },
		on_stdout = vim.schedule_wrap(function(err, output)
			if err == nil and output ~= nil then
				cb(output)
			end
		end),
	})

	branch_name_job:start()
end

M.is_gitlab_project = function(cb)
	M.is_inside_work_tree(function()
		M.get_remote_url(function(url)
			if string.find(url, "@gitlab") ~= nil then
				cb() -- If we are inside a git worktree, not on main/master, and in a Gitlab project...
			end
		end)
	end)
end

M.resolve_conflict = function()
	-- Get the current line and buffer
	local current_line = vim.api.nvim_win_get_cursor(0)[1]
	local buffer = vim.api.nvim_get_current_buf()

	-- Fetch lines around the cursor
	local lines = vim.api.nvim_buf_get_lines(buffer, current_line - 1, current_line + 10, false)

	-- Detect a conflict
	local conflict_start, conflict_middle, conflict_end
	for i, line in ipairs(lines) do
		if line:match("^<<<<") then
			conflict_start = current_line + i - 2
		elseif line:match("^====") then
			conflict_middle = current_line + i - 2
		elseif line:match("^>>>>") then
			conflict_end = current_line + i - 2
			break
		end
	end

	-- Ensure all markers are found
	if not (conflict_start and conflict_middle and conflict_end) then
		vim.notify("No conflict markers found.", vim.log.levels.ERROR)
		return
	end

	-- Prepare options
	local options = { "Top (yours)", "Bottom (theirs)" }

	vim.ui.select(options, { prompt = "Select conflict resolution:" }, function(choice)
		if choice then
			if choice == "Top (yours)" then
				vim.api.nvim_buf_set_lines(
					buffer,
					conflict_start,
					conflict_end + 1,
					false,
					vim.api.nvim_buf_get_lines(buffer, conflict_start + 1, conflict_middle, false)
				)
			elseif choice == "Bottom (theirs)" then
				vim.api.nvim_buf_set_lines(
					buffer,
					conflict_start,
					conflict_end + 1,
					false,
					vim.api.nvim_buf_get_lines(buffer, conflict_middle + 1, conflict_end, false)
				)
			end
			vim.notify("Conflict resolved with " .. choice .. ".", vim.log.levels.INFO)
		else
			vim.notify("Conflict resolution canceled.", vim.log.levels.WARN)
		end
	end)
end

-- See changes compared to staging, exclude generated files
vim.api.nvim_create_user_command("CHANGES", function()
	vim.cmd([[
    DiffviewOpen origin/staging -- ':(exclude)*/db/models/*'
  ]])
end, {})

M.open_blame_in_github = function()
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
	"<C-g>b",
	M.open_blame_in_github,
	{ desc = "Given the current line, opens up the commit in Github that made the change" }
)

---Return whether user is focused on the new version of the file
---@return boolean
M.is_current_sha_focused = function()
	local diffview_lib = require("diffview.lib")
	local view = diffview_lib.get_current_view()
	local layout = view.cur_layout
	local b_win = u.get_window_id_by_buffer_id(layout.b.file.bufnr)
	local current_win = vim.api.nvim_get_current_win()
	return current_win == b_win
end

---Return whether user is focused on the new version of the file
---@return string
M.get_file_path_in_reviewer = function()
	local diffview_lib = require("diffview.lib")
	local view = diffview_lib.get_current_view()
	local layout = view.cur_layout
	local b_win = u.get_window_id_by_buffer_id(layout.b.file.bufnr)
	local file_path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(b_win)), ":p:~:.")
	return file_path
end

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

return M
