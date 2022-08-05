local f = require("functions")
local u = require("functions.utils")

return {
	setup = function()
		local dap = require("dap")

		local node_debug_folder = u.get_home() .. "/dev/microsoft/vscode-node-debug2"
		if vim.fn.isdirectory(node_debug_folder) == 0 then
			f.run_script("install_node_debugger", u.get_home())
		end

		dap.adapters.node2 = {
			type = "executable",
			command = "node",
			args = { os.getenv("HOME") .. "/dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js" },
		}
		dap.configurations.javascript = {
			{
				name = "Launch",
				type = "node2",
				request = "launch",
				program = "${file}",
				cwd = vim.fn.getcwd(),
				sourceMaps = true,
				protocol = "inspector",
				console = "integratedTerminal",
			},
			{
				-- For this to work you need to make sure the node process is started with the `--inspect` flag.
				name = "Attach to process",
				type = "node2",
				request = "attach",
				processId = require("dap.utils").pick_process,
			},
		}

		dap.configurations.lua = {}

		vim.keymap.set("n", "<F5>", dap.continue)
		vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
	end,
}
