return {
	"ravitemer/mcphub.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	build = "bundled_build.lua", -- Bundles `mcp-hub` binary along with the neovim plugin
	config = function()
		require("mcphub").setup({
			use_bundled_binary = true, -- Use local `mcp-hub` binary
			config = vim.fn.expand("~/.config/nvim/lua/plugins/mcphub/servers.json"), -- Absolute path to MCP Servers config file (will create if not exists)
			port = 37373, -- The port `mcp-hub` server listens to
			shutdown_delay = 5 * 60 * 000, -- Delay in ms before shutting down the server when last instance closes (default: 5 minutes)
			mcp_request_timeout = 60000, --Max time allowed for a MCP tool or resource to execute in milliseconds, set longer for long running tasks
			global_env = function()
				return {
					REPOSITORY_PATH = vim.fn.getcwd(), -- Used by the git MCP
				}
			end, -- Global environment variables available to all MCP servers (can be a table or a function returning a table)
			workspace = {
				enabled = true, -- Enable project-local configuration files
				look_for = { ".mcphub/servers.json", ".vscode/mcp.json", ".cursor/mcp.json" }, -- Files to look for when detecting project boundaries (VS Code format supported)
				reload_on_dir_changed = true, -- Automatically switch hubs on DirChanged event
				port_range = { min = 40000, max = 41000 }, -- Port range for generating unique workspace ports
				get_port = nil, -- Optional function returning custom port number. Called when generating ports to allow custom port assignment logic
			},
			auto_approve = false, -- Auto approve mcp tool calls
			auto_toggle_mcp_servers = true, -- Let LLMs start and stop MCP servers automatically
			extensions = {
				avante = {
					make_slash_commands = true, -- make /slash commands from MCP server prompts
				},
			},
			native_servers = {}, -- add your custom lua native servers here
			builtin_tools = {
				edit_file = {
					parser = {
						track_issues = true,
						extract_inline_content = true,
					},
					locator = {
						fuzzy_threshold = 0.8,
						enable_fuzzy_matching = true,
					},
					ui = {
						go_to_origin_on_complete = true,
						keybindings = {
							accept = ".",
							reject = ",",
							next = "n",
							prev = "p",
							accept_all = "ga",
							reject_all = "gr",
						},
					},
				},
			},
			ui = {
				window = {
					width = 0.8, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
					height = 0.8, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
					align = "center", -- "center", "top-left", "top-right", "bottom-left", "bottom-right", "top", "bottom", "left", "right"
					relative = "editor",
					zindex = 50,
					border = "rounded", -- "none", "single", "double", "rounded", "solid", "shadow"
				},
				wo = { -- window-scoped options (vim.wo)
					winhl = "Normal:MCPHubNormal,FloatBorder:MCPHubBorder",
				},
			},
			json_decode = nil, -- Custom JSON parser function (e.g., require('json5').parse for JSON5 support)
			on_ready = function(hub)
				-- Called when hub is ready
			end,
			on_error = function(err)
				-- Called on errors
			end,
			log = {
				level = vim.log.levels.WARN,
				to_file = false,
				file_path = nil,
				prefix = "MCPHub",
			},
		})
	end,
}
