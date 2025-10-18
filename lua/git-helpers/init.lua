local M = {}
local map_opts = { noremap = true, silent = true, nowait = true }
local u = require("functions.utils")

local gitsigns_ok, gitsigns = pcall(require, "gitsigns")
local diffview_ok, _ = pcall(require, "diffview")
local plenary_ok, job = pcall(require, "plenary.job")
require("git-helpers.github")

if not gitsigns_ok or not diffview_ok or not plenary_ok then
	vim.api.nvim_err_writeln("Gitsigns, diffview, or plenary not installed, cannot configure Git tools")
	return
end

M.branch_input = function(callback)
	vim.ui.input({ prompt = "Enter branch/tag: " }, function(branch)
		if branch == nil or branch == "" then
			return
		end
		callback(branch)
	end)
end

-- Blame line
vim.keymap.set("n", "<leader>gb", gitsigns.blame_line, merge(global_keymap_opts, { desc = "Blame current line" }))

-- Hunk operations
vim.keymap.set("n", "<leader>ghn", function()
	gitsigns.next_hunk()
	gitsigns.preview_hunk()
end, merge(global_keymap_opts, { desc = "Next change" }))

vim.keymap.set("n", "<leader>ghp", function()
	gitsigns.prev_hunk()
	gitsigns.preview_hunk()
end, merge(global_keymap_opts, { desc = "Previous change" }))

vim.keymap.set("n", "<leader>ghr", gitsigns.reset_hunk, merge(global_keymap_opts, { desc = "Reset current hunk" }))
vim.keymap.set("n", "<leader>gha", gitsigns.stage_hunk, merge(global_keymap_opts, { desc = "Stage current hunk" }))

-- Adding/tracking files
vim.keymap.set("n", "<leader>gaa", function()
	M.add_all()
end, merge(global_keymap_opts, { desc = "Add all changes" }))

vim.keymap.set("n", "<leader>gac", function()
	M.add_current()
end, merge(global_keymap_opts, { desc = "Add current file" }))

-- Committing changes
vim.keymap.set("n", "<leader>gce", function()
	M.commit_easy()
end, merge(global_keymap_opts, { desc = "Easily commit current file" }))
vim.keymap.set("n", "<leader>gre", function()
	M.reset_easy_commits()
end, merge(global_keymap_opts, { desc = "Soft resets all recent easy commits" }))

-- Rebase
vim.keymap.set("n", "<leader>gR", function()
	M.branch_input(function(branch)
		local j = io.popen("git merge-base origin/" .. branch .. " HEAD")
		if j == nil then
			require("notify")("No commit hash found since staging!", vim.log.levels.ERROR)
			return
		end
		local non_easy_hash = vim.fn.trim(j:read("*a"))
		vim.cmd("Git rebase -i " .. non_easy_hash)
	end)
end, merge(global_keymap_opts, { desc = "Rebase against branch" }))

-- Initiate squash since branching from staging
vim.keymap.set("n", "<leader>gS", function()
	M.branch_input(function(branch)
		local j = io.popen("git merge-base origin/" .. branch .. " HEAD")
		if j == nil then
			require("notify")("No commit hash found since staging!", vim.log.levels.ERROR)
			return
		end

		local non_easy_hash = vim.fn.trim(j:read("*a"))
		vim.cmd("Git rebase -i " .. non_easy_hash)
	end)
end, map_opts)

-- Conflicts
vim.keymap.set("n", "<leader>gxx", function()
	M.resolve_conflict()
end, merge(global_keymap_opts, { desc = "Resolve conflict" }))

M.changed_files = function(branch)
	-- Committed changes
	local committed_files = vim.fn.system({ "git", "diff", "--name-only", "--diff-filter=ACM", branch .. "..." })
	-- Staged changes
	local staged_files = vim.fn.system({ "git", "diff", "--name-only", "--cached" })
	-- Untracked files
	local untracked_files = vim.fn.system({ "git", "ls-files", "-o", "--exclude-standard" })

	local lines =
		vim.split(committed_files .. "\n" .. staged_files .. "\n" .. untracked_files, "\n", { trimempty = true })
	local processed_files = {}
	local result = {}
	for _, file in ipairs(lines) do
		if
			file ~= ""
			and not processed_files[file]
			and not file:match(".*/db/models/.*")
			and not file:match(".*/db/models/.*")
		then
			processed_files[file] = true
			table.insert(result, { filename = file })
		end
	end
	return result
end

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

-- Commits the changes in a file quickly with a message "Updated %s [ci skip]"
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
		on_stderr = function(_, data)
			vim.notify("Error searching for PR: " .. table.concat(data, ""), vim.log.levels.ERROR)
		end,
	})
end

return M
