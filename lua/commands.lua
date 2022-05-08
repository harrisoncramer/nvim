local u = require("functions.utils")
vim.api.nvim_create_user_command("RL", function(opts)
	require("functions").reload(opts.args)
end, { nargs = "*" })

vim.api.nvim_create_user_command("RLC", function()
	require("functions").reload_current()
end, { nargs = 0 })

vim.api.nvim_create_user_command("SC", function()
	require("functions").shortcut()
end, { nargs = 0 })

vim.api.nvim_create_user_command("CAL", function()
	require("functions").calendar()
end, { nargs = 0 })

vim.api.nvim_create_user_command("Stash", function(opts)
  local name = opts.args ~= '' and opts.args or u.get_date_time()
  name = string.gsub(name, "%s+", "_")
	require("mappings.git").stash(name)
  print(string.format("Stashed %s", name))
end, { nargs = '?' })

vim.api.nvim_create_user_command("JQ", function()
	vim.api.nvim_command(".!jq .")
end, { nargs = 0 })

vim.api.nvim_create_user_command("Filesystem", function()
	require("functions").run_script("open_filesystem")
end, { nargs = 0 })
