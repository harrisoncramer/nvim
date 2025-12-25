vim.keymap.set("n", "<leader>ghrr", function()
	vim.cmd("Octo pr search")
end)

return {
	"pwntester/octo.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("octo").setup({
			picker = "snacks",
			use_local_fs = true,
			enable_builtin = false, -- shows a list of builtin actions when no action is provided
			default_remote = { "upstream", "origin" },
			default_merge_method = "merge", -- default merge method which should be used for both `Octo pr merge` and merging from picker, could be `merge`, `rebase` or `squash`
			default_delete_branch = false, -- whether to delete branch when merging pull request with either `Octo pr merge` or from picker (can be overridden with `delete`/`nodelete` argument to `Octo pr merge`)
			ssh_aliases = {}, -- SSH aliases. e.g. `ssh_aliases = {["github.com-work"] = "github.com"}`. The key part will be interpreted as an anchored Lua pattern.
			picker_config = {
				search_static = true, -- Whether to use static search results (true) or dynamic search (false)
				mappings = { -- mappings for the pickers
					open_in_browser = { lhs = "<C-b>", desc = "open issue in browser" },
					copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
					copy_sha = { lhs = "<C-e>", desc = "copy commit SHA to system clipboard" },
					checkout_pr = { lhs = "<C-o>", desc = "checkout pull request" },
					merge_pr = { lhs = "<C-r>", desc = "merge pull request" },
				},
				snacks = { -- snacks specific config
					actions = { -- custom actions for specific snacks pickers (array of tables)
						issues = { -- actions for the issues picker
							-- { name = "my_issue_action", fn = function(picker, item) print("Issue action:", vim.inspect(item)) end, lhs = "<leader>a", desc = "My custom issue action" },
						},
						pull_requests = { -- actions for the pull requests picker
							-- { name = "my_pr_action", fn = function(picker, item) print("PR action:", vim.inspect(item)) end, lhs = "<leader>b", desc = "My custom PR action" },
						},
						notifications = {}, -- actions for the notifications picker
						issue_templates = {}, -- actions for the issue templates picker
						search = {}, -- actions for the search picker
					},
				},
			},
			comment_icon = "▎", -- comment marker
			outdated_icon = "󰅒 ", -- outdated indicator
			resolved_icon = " ", -- resolved indicator
			reaction_viewer_hint_icon = " ", -- marker for user reactions
			commands = {}, -- additional subcommands made available to `Octo` command
			users = "search", -- Users for assignees or reviewers. Values: "search" | "mentionable" | "assignable"
			user_icon = " ", -- user icon
			ghost_icon = "󰊠 ", -- ghost icon
			copilot_icon = " ", -- copilot icon
			timeline_marker = " ", -- timeline marker
			timeline_indent = 2, -- timeline indentation
			use_timeline_icons = true, -- toggle timeline icons
			timeline_icons = { -- the default icons based on timelineItems
				auto_squash = "  ",
				commit_push = "  ",
				comment_deleted = " ",
				force_push = "  ",
				draft = "  ",
				ready = " ",
				commit = "  ",
				deployed = "  ",
				issue_type = "  ",
				label = "  ",
				reference = "  ",
				project = "  ",
				connected = "  ",
				subissue = "  ",
				cross_reference = "  ",
				transferred = "  ",
				parent_issue = "  ",
				head_ref = "  ",
				pinned = "  ",
				milestone = "  ",
				renamed = "  ",
				automatic_base_change_succeeded = "  ",
				base_ref_changed = "  ",
				merged = { "  ", "OctoPurple" },
				closed = {
					closed = { "  ", "OctoRed" },
					completed = { "  ", "OctoPurple" },
					not_planned = { "  ", "OctoGrey" },
					duplicate = { "  ", "OctoGrey" },
				},
				reopened = { "  ", "OctoGreen" },
				assigned = "  ",
				review_requested = "  ",
			},
			right_bubble_delimiter = "", -- bubble delimiter
			left_bubble_delimiter = "", -- bubble delimiter
			github_hostname = "", -- GitHub Enterprise host
			snippet_context_lines = 4, -- number or lines around commented lines
			gh_cmd = "gh", -- Command to use when calling Github CLI
			gh_env = {}, -- extra environment variables to pass on to GitHub CLI, can be a table or function returning a table
			timeout = 5000, -- timeout for requests between the remote server
			default_to_projects_v2 = false, -- use projects v2 for the `Octo card ...` command by default. Both legacy and v2 commands are available under `Octo cardlegacy ...` and `Octo cardv2 ...` respectively.
			-- Also disable sending v2 events into Github API.
			ui = {
				use_signcolumn = false, -- show "modified" marks on the sign column
				use_signstatus = true, -- show "modified" marks on the status column
			},
			issues = {
				order_by = { -- criteria to sort results of `Octo issue list`
					field = "CREATED_AT", -- either COMMENTS, CREATED_AT or UPDATED_AT (https://docs.github.com/en/graphql/reference/enums#issueorderfield)
					direction = "DESC", -- either DESC or ASC (https://docs.github.com/en/graphql/reference/enums#orderdirection)
				},
			},
			reviews = {
				auto_show_threads = true, -- automatically show comment threads on cursor move
				focus = "right", -- focus right buffer on diff open
			},
			runs = {
				icons = {
					pending = "🕖",
					in_progress = "🔄",
					failed = "❌",
					succeeded = "",
					skipped = "⏩",
					cancelled = "✖",
				},
			},
			pull_requests = {
				order_by = { -- criteria to sort the results of `Octo pr list`
					field = "CREATED_AT", -- either COMMENTS, CREATED_AT or UPDATED_AT (https://docs.github.com/en/graphql/reference/enums#issueorderfield)
					direction = "DESC", -- either DESC or ASC (https://docs.github.com/en/graphql/reference/enums#orderdirection)
				},
				always_select_remote_on_create = false, -- always give prompt to select base remote repo when creating PRs
				use_branch_name_as_title = false, -- sets branch name to be the name for the PR
			},
			notifications = {
				current_repo_only = false, -- show notifications for current repo only
			},
			file_panel = {
				size = 10, -- changed files panel rows
				use_icons = true, -- use web-devicons in file panel (if false, nvim-web-devicons does not need to be installed)
			},
			colors = { -- used for highlight groups (see Colors section below)
				white = "#ffffff",
				grey = "#2A354C",
				black = "#000000",
				red = "#fdb8c0",
				dark_red = "#da3633",
				green = "#acf2bd",
				dark_green = "#238636",
				yellow = "#d3c846",
				dark_yellow = "#735c0f",
				blue = "#58A6FF",
				dark_blue = "#0366d6",
				purple = "#6f42c1",
			},
			mappings_disable_default = false, -- disable default mappings if true, but will still adapt user mappings
			mappings = {
				discussion = {
					discussion_options = { lhs = "<CR>", desc = "show discussion options" },
					open_in_browser = { lhs = "<C-b>", desc = "open discussion in browser" },
					copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
					add_comment = { lhs = "<localleader>ca", desc = "add comment" },
					add_reply = { lhs = "<localleader>cr", desc = "add reply" },
					delete_comment = { lhs = "<localleader>cd", desc = "delete comment" },
					add_label = { lhs = "<localleader>la", desc = "add label" },
					remove_label = { lhs = "<localleader>ld", desc = "remove label" },
					next_comment = { lhs = "]c", desc = "go to next comment" },
					prev_comment = { lhs = "[c", desc = "go to previous comment" },
					react_hooray = { lhs = "<localleader>rp", desc = "add/remove 🎉 reaction" },
					react_heart = { lhs = "<localleader>rh", desc = "add/remove ❤️ reaction" },
					react_eyes = { lhs = "<localleader>re", desc = "add/remove 👀 reaction" },
					react_thumbs_up = { lhs = "<localleader>r+", desc = "add/remove 👍 reaction" },
					react_thumbs_down = { lhs = "<localleader>r-", desc = "add/remove 👎 reaction" },
					react_rocket = { lhs = "<localleader>rr", desc = "add/remove 🚀 reaction" },
					react_laugh = { lhs = "<localleader>rl", desc = "add/remove 😄 reaction" },
					react_confused = { lhs = "<localleader>rc", desc = "add/remove 😕 reaction" },
				},
				runs = {
					expand_step = { lhs = "o", desc = "expand workflow step" },
					open_in_browser = { lhs = "<C-b>", desc = "open workflow run in browser" },
					refresh = { lhs = "<C-r>", desc = "refresh workflow" },
					rerun = { lhs = "<C-o>", desc = "rerun workflow" },
					rerun_failed = { lhs = "<C-f>", desc = "rerun failed workflow" },
					cancel = { lhs = "<C-x>", desc = "cancel workflow" },
					copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
				},
				issue = {
					issue_options = { lhs = "<CR>", desc = "show issue options" },
					close_issue = { lhs = "<localleader>ic", desc = "close issue" },
					reopen_issue = { lhs = "<localleader>io", desc = "reopen issue" },
					list_issues = { lhs = "<localleader>il", desc = "list open issues on same repo" },
					reload = { lhs = "<C-r>", desc = "reload issue" },
					open_in_browser = { lhs = "<C-b>", desc = "open issue in browser" },
					copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
					add_assignee = { lhs = "<localleader>aa", desc = "add assignee" },
					remove_assignee = { lhs = "<localleader>ad", desc = "remove assignee" },
					create_label = { lhs = "<localleader>lc", desc = "create label" },
					add_label = { lhs = "<localleader>la", desc = "add label" },
					remove_label = { lhs = "<localleader>ld", desc = "remove label" },
					goto_issue = { lhs = "<localleader>gi", desc = "navigate to a local repo issue" },
					add_comment = { lhs = "<localleader>ca", desc = "add comment" },
					add_reply = { lhs = "<localleader>cr", desc = "add reply" },
					delete_comment = { lhs = "<localleader>cd", desc = "delete comment" },
					next_comment = { lhs = "]c", desc = "go to next comment" },
					prev_comment = { lhs = "[c", desc = "go to previous comment" },
					react_hooray = { lhs = "<localleader>rp", desc = "add/remove 🎉 reaction" },
					react_heart = { lhs = "<localleader>rh", desc = "add/remove ❤️ reaction" },
					react_eyes = { lhs = "<localleader>re", desc = "add/remove 👀 reaction" },
					react_thumbs_up = { lhs = "<localleader>r+", desc = "add/remove 👍 reaction" },
					react_thumbs_down = { lhs = "<localleader>r-", desc = "add/remove 👎 reaction" },
					react_rocket = { lhs = "<localleader>rr", desc = "add/remove 🚀 reaction" },
					react_laugh = { lhs = "<localleader>rl", desc = "add/remove 😄 reaction" },
					react_confused = { lhs = "<localleader>rc", desc = "add/remove 😕 reaction" },
				},
				pull_request = {
					pr_options = { lhs = "<CR>", desc = "show PR options" },
					checkout_pr = { lhs = "<localleader>po", desc = "checkout PR" },
					merge_pr = { lhs = "<localleader>pm", desc = "merge PR" },
					squash_and_merge_pr = { lhs = "<localleader>psm", desc = "squash and merge PR" },
					rebase_and_merge_pr = { lhs = "<localleader>prm", desc = "rebase and merge PR" },
					merge_pr_queue = {
						lhs = "<localleader>pq",
						desc = "merge commit PR and add to merge queue (Merge queue must be enabled in the repo)",
					},
					squash_and_merge_queue = {
						lhs = "<localleader>psq",
						desc = "squash and add to merge queue (Merge queue must be enabled in the repo)",
					},
					rebase_and_merge_queue = {
						lhs = "<localleader>prq",
						desc = "rebase and add to merge queue (Merge queue must be enabled in the repo)",
					},
					list_commits = { lhs = "<localleader>pc", desc = "list PR commits" },
					list_changed_files = { lhs = "<localleader>pf", desc = "list PR changed files" },
					show_pr_diff = { lhs = "<localleader>pd", desc = "show PR diff" },
					add_reviewer = { lhs = "<localleader>va", desc = "add reviewer" },
					remove_reviewer = { lhs = "<localleader>vd", desc = "remove reviewer request" },
					close_issue = { lhs = "<localleader>ic", desc = "close PR" },
					reopen_issue = { lhs = "<localleader>io", desc = "reopen PR" },
					list_issues = { lhs = "<localleader>il", desc = "list open issues on same repo" },
					reload = { lhs = "<C-r>", desc = "reload PR" },
					open_in_browser = { lhs = "<C-b>", desc = "open PR in browser" },
					copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
					goto_file = { lhs = "gf", desc = "go to file" },
					add_assignee = { lhs = "<localleader>aa", desc = "add assignee" },
					remove_assignee = { lhs = "<localleader>ad", desc = "remove assignee" },
					create_label = { lhs = "<localleader>lc", desc = "create label" },
					add_label = { lhs = "<localleader>la", desc = "add label" },
					remove_label = { lhs = "<localleader>ld", desc = "remove label" },
					goto_issue = { lhs = "<localleader>gi", desc = "navigate to a local repo issue" },
					add_comment = { lhs = "<localleader>ca", desc = "add comment" },
					add_reply = { lhs = "<localleader>cr", desc = "add reply" },
					delete_comment = { lhs = "<localleader>cd", desc = "delete comment" },
					next_comment = { lhs = "]c", desc = "go to next comment" },
					prev_comment = { lhs = "[c", desc = "go to previous comment" },
					react_hooray = { lhs = "<localleader>rp", desc = "add/remove 🎉 reaction" },
					react_heart = { lhs = "<localleader>rh", desc = "add/remove ❤️ reaction" },
					react_eyes = { lhs = "<localleader>re", desc = "add/remove 👀 reaction" },
					react_thumbs_up = { lhs = "<localleader>r+", desc = "add/remove 👍 reaction" },
					react_thumbs_down = { lhs = "<localleader>r-", desc = "add/remove 👎 reaction" },
					react_rocket = { lhs = "<localleader>rr", desc = "add/remove 🚀 reaction" },
					react_laugh = { lhs = "<localleader>rl", desc = "add/remove 😄 reaction" },
					react_confused = { lhs = "<localleader>rc", desc = "add/remove 😕 reaction" },
					review_start = { lhs = "<localleader>vs", desc = "start a review for the current PR" },
					review_resume = { lhs = "<localleader>vr", desc = "resume a pending review for the current PR" },
					resolve_thread = { lhs = "<localleader>rt", desc = "resolve PR thread" },
					unresolve_thread = { lhs = "<localleader>rT", desc = "unresolve PR thread" },
				},
				review_thread = {
					goto_issue = { lhs = "<localleader>gi", desc = "navigate to a local repo issue" },
					add_comment = { lhs = "<localleader>ca", desc = "add comment" },
					add_reply = { lhs = "<localleader>cr", desc = "add reply" },
					add_suggestion = { lhs = "<localleader>sa", desc = "add suggestion" },
					delete_comment = { lhs = "<localleader>cd", desc = "delete comment" },
					next_comment = { lhs = "]c", desc = "go to next comment" },
					prev_comment = { lhs = "[c", desc = "go to previous comment" },
					select_next_entry = { lhs = "<C-n>", desc = "move to next changed file" },
					select_prev_entry = { lhs = "<C-p>", desc = "move to previous changed file" },
					select_first_entry = { lhs = "[Q", desc = "move to first changed file" },
					select_last_entry = { lhs = "]Q", desc = "move to last changed file" },
					select_next_unviewed_entry = { lhs = "]u", desc = "move to next unviewed changed file" },
					select_prev_unviewed_entry = { lhs = "[u", desc = "move to previous unviewed changed file" },
					close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
					react_hooray = { lhs = "<localleader>rp", desc = "add/remove 🎉 reaction" },
					react_heart = { lhs = "<localleader>rh", desc = "add/remove ❤️ reaction" },
					react_eyes = { lhs = "<localleader>re", desc = "add/remove 👀 reaction" },
					react_thumbs_up = { lhs = "<localleader>r+", desc = "add/remove 👍 reaction" },
					react_thumbs_down = { lhs = "<localleader>r-", desc = "add/remove 👎 reaction" },
					react_rocket = { lhs = "<localleader>rr", desc = "add/remove 🚀 reaction" },
					react_laugh = { lhs = "<localleader>rl", desc = "add/remove 😄 reaction" },
					react_confused = { lhs = "<localleader>rc", desc = "add/remove 😕 reaction" },
					resolve_thread = { lhs = "<localleader>rt", desc = "resolve PR thread" },
					unresolve_thread = { lhs = "<localleader>rT", desc = "unresolve PR thread" },
				},
				submit_win = {
					approve_review = { lhs = "<C-a>", desc = "approve review", mode = { "n", "i" } },
					comment_review = { lhs = "<C-m>", desc = "comment review", mode = { "n", "i" } },
					request_changes = { lhs = "<C-r>", desc = "request changes review", mode = { "n", "i" } },
					close_review_tab = { lhs = "<C-c>", desc = "close review tab", mode = { "n", "i" } },
				},
				review_diff = {
					submit_review = { lhs = "<localleader>vs", desc = "submit review" },
					discard_review = { lhs = "<localleader>vd", desc = "discard review" },
					add_review_comment = {
						lhs = "<localleader>ca",
						desc = "add a new review comment",
						mode = { "n", "x" },
					},
					add_review_suggestion = {
						lhs = "<localleader>sa",
						desc = "add a new review suggestion",
						mode = { "n", "x" },
					},
					focus_files = { lhs = "<localleader>e", desc = "move focus to changed file panel" },
					toggle_files = { lhs = "<localleader>b", desc = "hide/show changed files panel" },
					next_thread = { lhs = "]t", desc = "move to next thread" },
					prev_thread = { lhs = "[t", desc = "move to previous thread" },
					select_next_entry = { lhs = "<C-n>", desc = "move to next changed file" },
					select_prev_entry = { lhs = "<C-p>", desc = "move to previous changed file" },
					select_first_entry = { lhs = "[Q", desc = "move to first changed file" },
					select_last_entry = { lhs = "]Q", desc = "move to last changed file" },
					select_next_unviewed_entry = { lhs = "]u", desc = "move to next unviewed changed file" },
					select_prev_unviewed_entry = { lhs = "[u", desc = "move to previous unviewed changed file" },
					close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
					toggle_viewed = { lhs = "<localleader><space>", desc = "toggle viewer viewed state" },
					goto_file = { lhs = "gf", desc = "go to file" },
				},
				file_panel = {
					submit_review = { lhs = "<localleader>vs", desc = "submit review" },
					discard_review = { lhs = "<localleader>vd", desc = "discard review" },
					next_entry = { lhs = "j", desc = "move to next changed file" },
					prev_entry = { lhs = "k", desc = "move to previous changed file" },
					select_entry = { lhs = "<cr>", desc = "show selected changed file diffs" },
					refresh_files = { lhs = "R", desc = "refresh changed files panel" },
					focus_files = { lhs = "<localleader>e", desc = "move focus to changed file panel" },
					toggle_files = { lhs = "<localleader>b", desc = "hide/show changed files panel" },
					select_next_entry = { lhs = "<C-n>", desc = "move to next changed file" },
					select_prev_entry = { lhs = "<C-p>", desc = "move to previous changed file" },
					select_first_entry = { lhs = "[Q", desc = "move to first changed file" },
					select_last_entry = { lhs = "]Q", desc = "move to last changed file" },
					select_next_unviewed_entry = { lhs = "]u", desc = "move to next unviewed changed file" },
					select_prev_unviewed_entry = { lhs = "[u", desc = "move to previous unviewed changed file" },
					close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
					toggle_viewed = { lhs = "<localleader><space>", desc = "toggle viewer viewed state" },
				},
				notification = {
					read = { lhs = "<localleader>nr", desc = "mark notification as read" },
					done = { lhs = "<localleader>nd", desc = "mark notification as done" },
					unsubscribe = { lhs = "<localleader>nu", desc = "unsubscribe from notifications" },
				},
				repo = {
					repo_options = { lhs = "<CR>", desc = "show repo options" },
					create_issue = { lhs = "<localleader>ic", desc = "create issue" },
					create_discussion = { lhs = "<localleader>dc", desc = "create discussion" },
					contributing_guidelines = { lhs = "<localleader>cg", desc = "view contributing guidelines" },
					open_in_browser = { lhs = "<C-b>", desc = "open repo in browser" },
				},
				release = {
					open_in_browser = { lhs = "<C-b>", desc = "open release in browser" },
				},
			},
		})
	end,
}
