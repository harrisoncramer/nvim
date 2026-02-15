local u = require("functions.utils")
local services = require("plugins.dap.services")

local M = {}

vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "🟠", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "🟢", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "🚫", texthl = "", linehl = "", numhl = "" })

M.setup_ui = function(dap, ui)
	vim.keymap.set("n", "<localleader>de", function()
		dap.clear_breakpoints()
		dap.terminate({}, { terminateDebuggee = true }, function()
			vim.cmd.bd()
			u.resize_vertical_splits()
			require("notify")("Debug process killed", vim.log.levels.WARN)
		end)
	end, merge(global_keymap_opts, { desc = "Disconnects the debugger and ends debugging" }))

	vim.keymap.set("n", "<localleader>dC", function()
		dap.clear_breakpoints()
		require("notify")("Breakpoints cleared", vim.log.levels.WARN)
	end, merge(global_keymap_opts, { desc = "Clears all breakpoints" }))

	vim.keymap.set("n", "<localleader>da", function()
		services.attach_to_service(dap, ui)
	end, merge(global_keymap_opts, { desc = "Attach to running service" }))

	-- Other keybindings
	vim.keymap.set("n", "<localleader>dl", require("dap.ui.widgets").hover)
	vim.keymap.set("n", "<localleader>dc", dap.continue)
	vim.keymap.set("n", "<localleader>db", dap.toggle_breakpoint)
	vim.keymap.set("n", "<localleader>dn", dap.step_over)
	vim.keymap.set("n", "<localleader>di", dap.step_into)
	vim.keymap.set("n", "<localleader>do", dap.step_out)
	vim.keymap.set("n", "<localleader>dr", function()
		dap.run_last()
	end) -- Repeat last command, e.g. attach to PID

	-- ╭────────────────────────────────────────────╮
	-- │ UI                                         │
	-- ╰────────────────────────────────────────────╯
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
end

return M
