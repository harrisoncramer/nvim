-- The LSP in 0.7 is not working, so we're adding this compatability layer for now.
-- Eventually, all calls to require('compat').remap can be replaced and simplified,
-- and we will also not need to export these functions.
return {
	remap = function(mode, lhs, rhs, opts, fallback)
		if vim_version < 7 then
			vim.api.nvim_set_keymap(mode, lhs, fallback, { silent = true })
		else
			vim.keymap.set(mode, lhs, function()
				rhs(opts)
			end)
		end
	end,
}
