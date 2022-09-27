local u = require("functions.utils")

local toggle_status = function()
	local ft = vim.bo.filetype
	if ft == "fugitive" then
		vim.api.nvim_command("bd")
	else
		vim.api.nvim_command("Git")
	end
end

local git_push = function()
	local isSubmodule = vim.fn.trim(vim.fn.system("git rev-parse --show-superproject-working-tree"))
	if isSubmodule == "" then
		if u.get_os() == "Linux" then
			vim.api.nvim_command("Git push")
		else
			vim.api.nvim_command("! git push")
		end
	else
		vim.fn.confirm("Push to origin/main branch for submodule?")
		vim.api.nvim_command("silent ! git push origin HEAD:main")
	end
	local branch = u.get_branch_name()
	require("notify")("Pushed to '" .. branch .. "' branch")
end

local git_open = function()
	vim.api.nvim_command("! git open")
end

local git_mr_open = function()
	if u.get_os() == "Linux" then
		os.execute(
			string.format(
				"firefox --new-tab 'https://gitlab.com/crossbeam/%s/-/merge_requests?scope=all&state=opened&author_username=hcramer1'",
				u.current_dir()
			)
		)
	end
end

vim.keymap.set("n", "<leader>gs", toggle_status, {})
vim.keymap.set("n", "<leader>gP", git_push, {})
vim.keymap.set("n", "<leader>goo", git_open, {})
vim.keymap.set("n", "<leader>gom", git_mr_open, {})

vim.cmd([[
  function! s:ftplugin_fugitive() abort
      nnoremap <buffer> <silent> cc :Git commit --quiet<CR>
      nnoremap <buffer> <silent> ca :Git commit --quiet --amend<CR>
      nnoremap <buffer> <silent> ce :Git commit --quiet --amend --no-edit<CR>
    endfunction
    augroup nhooyr_fugitive
      autocmd!
      autocmd FileType fugitive call s:ftplugin_fugitive()
    augroup END
]])

vim.cmd([[

" Open diff of current file in new tab
function! GStatusGetFilenameUnderCursor()
    return matchstr(getline('.'), '^[A-Z?] \zs.*')
endfunction

command! GdiffsplitTab call GdiffsplitTab(expand("%"))
function! GdiffsplitTab(filename)
    exe 'tabedit ' . a:filename
    Gdiffsplit
endfunction

" custom mapping in fugitive window (:Git)
augroup custom_fugitive_mappings
    au!
    au User FugitiveIndex nnoremap <buffer> <leader>df :call GdiffsplitTab(GStatusGetFilenameUnderCursor())<cr>
    au User FugitiveIndex nnoremap <buffer> <C-n> :lua require("plugins.fugitive").jump_next()<CR>
    au User FugitiveIndex nnoremap <buffer> <C-p> :lua require("plugins.fugitive").jump_prev()<CR>
    au User FugitiveIndex nnoremap <buffer> sj <C-w>j
augroup END

]])

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "COMMIT_EDITMSG",
	callback = function()
		require("close_buffers").delete({ regex = "^fugitive*" })
		require("notify")("Commit saved!")
	end,
})

return {
	jump_next = function()
		vim.api.nvim_feedkeys("/^[?,M,A,D,U] ", "n", false)
		u.press_enter()
		vim.api.nvim_feedkeys(":noh", "n", false)
		u.press_enter()
	end,
	jump_prev = function()
		vim.api.nvim_feedkeys("?^[?,M,A,D,U] ", "n", false)
		u.press_enter()
		vim.api.nvim_feedkeys(":noh", "n", false)
		u.press_enter()
	end,
}
