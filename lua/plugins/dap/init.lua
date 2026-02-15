return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"leoluz/nvim-dap-go",
		"nvim-neotest/nvim-nio",
		"rcarriga/nvim-dap-ui",
	},
	config = function(_, opts)
		local dap = require("dap")
		local dapui = require("dapui")
		require("dap-go").setup(opts)

		dap.listeners.before.event_terminated.dapui_config = function()
			pcall(dapui.close)
		end
		dap.listeners.before.event_exited.dapui_config = function()
			pcall(dapui.close)
		end
		require("plugins.dap.ui").setup_ui(dap, dapui)
	end,
}
