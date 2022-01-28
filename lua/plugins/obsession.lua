return {
	setup = function()
		vim.cmd([[command! CreateOrRestoreSession :lua require("functions").createOrRestoreSession() ]])
	end,
}
