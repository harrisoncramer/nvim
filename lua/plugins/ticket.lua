return {
	setup = function(remap)
		remap({ "n", "<leader>ss", ":SaveSession<CR>" })
		remap({ "n", "<leader>so", ":OpenSession<CR>" })
	end,
}
