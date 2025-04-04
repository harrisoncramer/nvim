local u = require("functions.utils")
return {
	"rcarriga/nvim-dap-ui",
	dependencies = {
		"jay-babu/mason-nvim-dap.nvim",
		"mfussenegger/nvim-dap",
		"nvim-neotest/nvim-nio",
		"williamboman/mason.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_dap = require("mason-nvim-dap")
		local dap = require("dap")
		local ui = require("dapui")

		dap.set_log_level("TRACE")

		-- ╭──────────────────────────────────────────────────────────╮
		-- │ Debuggers                                                │
		-- ╰──────────────────────────────────────────────────────────╯
		-- We need the actual programs to connect to running instances of our code.
		-- Debuggers are installed via https://github.com/jayp0521/mason-nvim-dap.nvim
		mason.setup()
		mason_dap.setup({
			ensure_installed = {
				"delve@v1.20.2",
				"js@v1.77.0",
				-- "node2@v1.43.0", TODO: Not working
			},
			automatic_installation = true,
		})

		dap.configurations.go = {
			{
				name = "Compliance",
				type = "go",
				request = "attach",
				port = 2354,
				host = "127.0.0.1",
				showLog = true,
				apiVersion = 2,
				trace = "verbose",
				mode = "remote",
				substitutePath = {
					{
						from = "${workspaceFolder}/apps/compliance",
						to = "/app",
					},
				},
			},
			{
				type = "go",
				name = "Attach",
				request = "attach",
				mode = "remote",
				host = "127.0.0.1",
				port = 8498,
				showLog = true,
				apiVersion = 2,
				trace = "verbose",
				dlvToolPath = vim.fn.exepath("dlv"), -- Adjust to where delve is installed
			},
			{
				type = "go",
				name = "Run (and debug)",
				request = "launch",
				showLog = false,
				program = "${file}",
				dlvToolPath = vim.fn.exepath("dlv"), -- Adjust to where delve is installed
			},
		}

		dap.adapters.go = {
			type = "executable",
			command = "node",
			args = { "/Users/harrisoncramer/vscode-go/extension/dist/debugAdapter.js" },
		}

		-- ╭──────────────────────────────────────────────────────────╮
		-- │ Keybindings + UI                                         │
		-- ╰──────────────────────────────────────────────────────────╯
		vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
		vim.fn.sign_define("DapBreakpointCondition", { text = "🟠", texthl = "", linehl = "", numhl = "" })
		vim.fn.sign_define("DapStopped", { text = "🟢", texthl = "", linehl = "", numhl = "" })
		vim.fn.sign_define("DapBreakpointRejected", { text = "🚫", texthl = "", linehl = "", numhl = "" })

		-- Opens up the debugger tab if it's not currently active
		local function dap_start_debugging()
			local has_dap_repl = false
			for _, buf in ipairs(vim.fn.tabpagebuflist()) do
				if vim.bo[buf].filetype == "dap-repl" then
					has_dap_repl = true
					break
				end
			end

			if not has_dap_repl then
				vim.cmd("tabedit %")
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-o>", false, true, true), "n", false)
				ui.toggle({})
			end
			dap.continue({})
		end
		vim.keymap.set("n", "<localleader>ds", dap_start_debugging)

		-- Detaches the debugger
		local function dap_end_debug()
			dap.disconnect({ terminateDebuggee = false }, function()
				require("notify")("Debugger detached", vim.log.levels.INFO)
			end)
		end
		vim.keymap.set("n", "<localleader>de", dap_end_debug)

		-- Kills the debug process
		local function dap_kill_debug_process()
			dap.clear_breakpoints()
			dap.terminate({}, { terminateDebuggee = true }, function()
				vim.cmd.bd()
				u.resize_vertical_splits()
				require("notify")("Debug process killed", vim.log.levels.WARN)
			end)
		end
		vim.keymap.set("n", "<localleader>dk", dap_kill_debug_process)

		-- Bulk clear all breakpoints
		local function dap_clear_breakpoints()
			dap.clear_breakpoints()
			require("notify")("Breakpoints cleared", vim.log.levels.WARN)
		end

		vim.keymap.set("n", "<localleader>dC", dap_clear_breakpoints)

		-- Other keybindings
		vim.keymap.set("n", "<localleader>dl", require("dap.ui.widgets").hover)
		vim.keymap.set("n", "<localleader>dc", dap.continue)
		vim.keymap.set("n", "<localleader>db", dap.toggle_breakpoint)
		vim.keymap.set("n", "<localleader>dn", dap.step_over)
		vim.keymap.set("n", "<localleader>di", dap.step_into)
		vim.keymap.set("n", "<localleader>do", dap.step_out)
		vim.keymap.set("n", "<localleader>dr", function()
			require("dap").run_last()
		end) -- Repeat last command, e.g. attach to PID

		-- UI Settings
		ui.setup({
			controls = {
				element = "repl",
				enabled = true,
				icons = {
					disconnect = "",
					pause = "",
					play = "",
					run_last = "",
					step_back = "",
					step_into = "",
					step_out = "",
					step_over = "",
					terminate = "",
				},
			},
			element_mappings = {},
			expand_lines = true,
			floating = {
				border = "single",
				mappings = {
					close = { "q", "<Esc>" },
				},
			},
			force_buffers = true,
			icons = {
				collapsed = "",
				current_frame = "",
				expanded = "",
			},
			layouts = {
				{
					elements = {
						"scopes",
					},
					size = 0.3,
					position = "bottom",
				},
				{
					elements = {
						"repl",
						"breakpoints",
					},
					size = 0.3,
					position = "right",
				},
			},
			mappings = {
				edit = "e",
				expand = { "t", "<2-LeftMouse>" },
				remove = "d",
				repl = {},
				open = {},
				toggle = {},
			},
			render = {
				indent = 1,
				max_value_lines = 100,
			},
		})
	end,
}
