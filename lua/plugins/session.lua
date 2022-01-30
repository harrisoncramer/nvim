local get_branch_name = require("functions").get_branch_name

local opts = {
	log_level = "info",
	auto_session_suppress_dirs = nil,
}

return {
	setup = function()
		local branch = get_branch_name()
		if branch then
			opts.auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/" .. get_branch_name() .. "/"
			opts.auto_session_enable_last_session = true
			opts.auto_session_enabled = true
			opts.auto_save_enabled = true
			opts.auto_restore_enabled = true
			require("auto-session").setup(opts)
		end
	end,
}
