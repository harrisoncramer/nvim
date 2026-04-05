return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"leoluz/nvim-dap-go",
		"nvim-neotest/nvim-nio",
		{
			"rcarriga/nvim-dap-ui",
			version = "v2.6.0", -- Latest version has bug, see: https://github.com/rcarriga/nvim-dap-ui/issues/371
			pin = true,
		},
	},
	config = function(_, opts)
		local dap = require("dap")
		local dapui = require("dapui")
		require("dap-go").setup(opts)

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end
		require("plugins.dap.ui").setup_ui(dap, dapui)
	end,
}
