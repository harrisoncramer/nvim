local get_branch_name = require("functions").get_branch_name

local opts = {
	log_level = "info",
	auto_session_suppress_dirs = nil,
	pre_save_cmds = { "lua require'nvim-tree'.setup()", "tabdo NvimTreeClose" },
}

return {
	setup = function()
		-- Only run for git projects
		local branch = get_branch_name()
		if branch then
			opts.auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/"
			opts.auto_session_enabled = true
			opts.auto_save_enabled = true
			opts.auto_session_enable_last_session = false
			opts.auto_restore_enabled = false
			require("auto-session").setup(opts)
		else
			vim.cmd([[
        let g:auto_session_enabled = v:false
      ]])
		end
	end,
}
