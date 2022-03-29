vim.api.nvim_add_user_command("RL", function(opts)
	require("functions").reload(opts.args)
end, { nargs = "*" })

vim.api.nvim_add_user_command("RLC", function()
	require("functions").reload_current()
end, { nargs = 0 })

vim.api.nvim_add_user_command("SC", function()
	require("functions").shortcut()
end, { nargs = 0 })

vim.api.nvim_add_user_command("CAL", function()
	require("functions").calendar()
end, { nargs = 0 })

vim.api.nvim_add_user_command("Stash", function(opts)
	require("mappings.git").stash(opts.args)
end, { nargs = 1 })

vim.api.nvim_add_user_command("JQ", function()
	vim.api.nvim_command(".!jq .")
end, { nargs = 0 })
