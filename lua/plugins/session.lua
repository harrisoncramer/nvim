local get_branch_name = require("functions").get_branch_name

local opts = {
	log_level = "info",
	auto_session_enable_last_session = true,
	auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/" .. get_branch_name() .. "/",
	auto_session_enabled = true,
	auto_save_enabled = true,
	auto_restore_enabled = true,
	auto_session_suppress_dirs = nil,
	pre_save_cmds = { "lua require'nvim-tree'.setup()", "tabdo NvimTreeClose" },
}

return {
	setup = function()
		local branch = get_branch_name()
		print(branch)
		require("auto-session").setup(opts)
	end,
}
