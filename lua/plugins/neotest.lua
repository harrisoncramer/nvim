local notify = require("notify")
local Job = require("plenary.job")

local function start_test_db(cb)
	Job:new({
		command = "sh",
		args = {
			"-c",
			"docker compose --profile test up -d test-db",
		},
		cwd = "~/chariot/chariot",
		on_exit = function(j, return_val)
			if return_val == 0 then
				notify("Started test DB...", vim.log.levels.INFO)
				vim.schedule(function()
					cb()
				end)
			else
				vim.print("Failed to start Test DB")
				vim.print(j:stderr_result()) -- Ensure errors are captured
			end
		end,
	}):start()
end

local u = require("functions.utils")
vim.api.nvim_create_autocmd("FileType", {
	pattern = "neotest-summary",
	callback = function()
		vim.wo.wrap = false
	end,
})
return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"antoinemadec/FixCursorHold.nvim",
		"marilari88/neotest-vitest",
		"nvim-nio",
		{ "fredrikaverpil/neotest-golang", version = "*" }, -- Installation
	},
	config = function()
		local neotest = require("neotest")
		local map_opts = { noremap = true, silent = true, nowait = true }
		local colors = require("colorscheme")

		-- get neotest namespace (api call creates or returns namespace)
		local neotest_ns = vim.api.nvim_create_namespace("neotest")
		vim.diagnostic.config({
			virtual_text = {
				format = function(diagnostic)
					local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
					return message
				end,
			},
		}, neotest_ns)

		require("neotest").setup({
			quickfix = {
				open = false,
				enabled = false,
			},
			status = {
				enabled = true,
				signs = true, -- Sign after function signature
				virtual_text = false,
			},
			icons = {
				child_indent = "│",
				child_prefix = "├",
				collapsed = "─",
				expanded = "╮",
				failed = "✘",
				final_child_indent = " ",
				final_child_prefix = "╰",
				non_collapsible = "─",
				passed = "✓",
				running = "",
				running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
				skipped = "↓",
				unknown = "",
			},
			floating = {
				border = "rounded",
				max_height = 0.9,
				max_width = 0.9,
				options = {},
			},
			summary = {
				open = "botright vsplit | vertical resize 60",
				mappings = {
					attach = "a",
					clear_marked = "M",
					clear_target = "T",
					debug = "d",
					debug_marked = "D",
					expand = { "<CR>", "<2-LeftMouse>" },
					expand_all = "e",
					jumpto = "i",
					mark = "m",
					next_failed = "J",
					output = "o",
					prev_failed = "K",
					run = "r",
					run_marked = "R",
					short = "O",
					stop = "u",
					target = "t",
					watch = "w",
				},
			},
			highlights = {
				adapter_name = "NeotestAdapterName",
				border = "NeotestBorder",
				dir = "NeotestDir",
				expand_marker = "NeotestExpandMarker",
				failed = "NeotestFailed",
				file = "NeotestFile",
				focused = "NeotestFocused",
				indent = "NeotestIndent",
				marked = "NeotestMarked",
				namespace = "NeotestNamespace",
				passed = "NeotestPassed",
				running = "NeotestRunning",
				select_win = "NeotestWinSelect",
				skipped = "NeotestSkipped",
				target = "NeotestTarget",
				test = "NeotestTest",
				unknown = "NeotestUnknown",
			},
			adapters = {
				require("neotest-vitest"),
				require("neotest-golang")(),
			},
		})

		vim.api.nvim_set_hl(0, "NeotestBorder", { fg = colors.fujiGray })
		vim.api.nvim_set_hl(0, "NeotestIndent", { fg = colors.fujiGray })
		vim.api.nvim_set_hl(0, "NeotestExpandMarker", { fg = colors.fujiGray })
		vim.api.nvim_set_hl(0, "NeotestDir", { fg = colors.fujiGray })
		vim.api.nvim_set_hl(0, "NeotestFile", { fg = colors.fujiGray })
		vim.api.nvim_set_hl(0, "NeotestFailed", { fg = colors.samuraiRed })
		vim.api.nvim_set_hl(0, "NeotestPassed", { fg = colors.springGreen })
		vim.api.nvim_set_hl(0, "NeotestSkipped", { fg = colors.fujiGray })
		vim.api.nvim_set_hl(0, "NeotestRunning", { fg = colors.carpYellow })
		vim.api.nvim_set_hl(0, "NeotestNamespace", { fg = colors.crystalBlue })
		vim.api.nvim_set_hl(0, "NeotestAdapterName", { fg = colors.oniViolet })

		local test_args = {
			env = {
				AWS_TEMPLATE_BUCKET = "fake-bucket",
				TEST_DATABASE_URL_BASE = os.getenv("TEST_DATABASE_URL_BASE"),
				TEST_DATABASE_URL = os.getenv("TEST_DATABASE_URL"),
				TEST_DATABASE_NAME = os.getenv("TEST_DATABASE_NAME"),
				CHARIOT_API_KEY = os.getenv("CHARIOT_API_KEY"),
			},
		}

		vim.keymap.set("n", "<localleader>tdb", start_test_db, merge({ desc = "Start test DB" }))

		vim.keymap.set("n", "<localleader>tfr", function()
			neotest.run.run({ vim.fn.expand("%"), env = test_args.env })
		end, merge(global_keymap_opts, { desc = "Run focused test" }))

		vim.keymap.set("n", "<localleader>tr", function()
			neotest.run.run(test_args)
			neotest.summary.open()
		end, merge(global_keymap_opts, { desc = "Run all tests" }))

		vim.keymap.set("n", "<localleader>to", function()
			neotest.output.open({ last_run = true, enter = true })
		end, merge(global_keymap_opts, { desc = "Open output" }))

		vim.keymap.set("n", "<localleader>tt", function()
			neotest.summary.toggle()
			u.resize_vertical_splits()
		end, merge(global_keymap_opts, { desc = "Toggle test summary" }))

		vim.keymap.set("n", "<localleader>tl", function()
			neotest.run.run_last(merge({ enter = true }, test_args))
			neotest.output.open({ last_run = true, enter = true })
		end, merge(global_keymap_opts, { desc = "Run last test" }))
	end,
}
