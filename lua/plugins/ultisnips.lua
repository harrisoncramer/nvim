return {
	setup = function(remap)
		vim.g.UltiSnipsSnippetsDir = "~/.config/nvim/_snippets"
		vim.cmd([[ let g:UltiSnipsSnippetDirectories = ['_snippets'] ]])

		vim.g.UltiSnipsExpandTrigger = "<C-o>"
		vim.g.UltiSnipsJumpForwardTrigger = "<c-j>"
		vim.g.UltiSnipsJumpBackwardTrigger = "<c-l>"

		-- Turn on Ultisnips in Javascript file for javascriptreact files
		vim.cmd([[ autocmd FileType javascriptreact UltiSnipsAddFiletypes javascript ]])
	end,
}
