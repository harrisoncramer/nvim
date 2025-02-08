vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*.proto",
	callback = function()
		vim.cmd("silent !clang-format -i --style=Google %")
	end,
	desc = "Run clang formatter on save in proto files. We can't attach the clangd LSP because it's stupid.",
})
