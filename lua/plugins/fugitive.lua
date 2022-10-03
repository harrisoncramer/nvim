local u = require("functions.utils")
local async_job, job = pcall(require, 'plenary.job')

local toggle_status = function()
  local ft = vim.bo.filetype
  if ft == "fugitive" then
    vim.api.nvim_command("bd")
  else
    local fugitive_tab = u.get_tab_by_buf_name("fugitive", true)
    if fugitive_tab ~= -1 then
      vim.api.nvim_set_current_tabpage(fugitive_tab)
    end
    vim.api.nvim_command(":Git")
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>T", false, true, true), "n", false)
    require("plugins.fugitive").jump_next()
  end
end

local git_push = function()

  if not async_job then
    require("notify")("Plenary is not installed!", "error")
  end

  local push_job = job:new({
    command = 'git',
    args = { 'push' },
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        require("notify")("Could not push!", "error")
        return
      end
      require("notify")("Pushed.")
    end,
  })

  local isSubmodule = vim.fn.trim(vim.fn.system("git rev-parse --show-superproject-working-tree"))
  if isSubmodule == "" then
    push_job:start()
  else
    vim.fn.confirm("Push to origin/main branch for submodule?")
    push_job:start()
  end
end

local git_open = function()
  vim.api.nvim_command("! git open")
end

local git_mr_open = function()
  if u.get_os() == "Linux" then
    os.execute(
      string.format(
        "firefox --new-tab 'https://gitlab.com/crossbeam/%s/-/merge_requests?scope=all&state=opened&author_username=hcramer1'"
        ,
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
  end,
})

return {
  jump_next = function()
    vim.api.nvim_feedkeys(":silent! /^[?,M,A,D,U] ", "n", false)
    u.press_enter()
    vim.api.nvim_feedkeys(":noh", "n", false)
    u.press_enter()
  end,
  jump_prev = function()
    vim.api.nvim_feedkeys(":silent! ?^[?,M,A,D,U] ", "n", false)
    u.press_enter()
    vim.api.nvim_feedkeys(":noh", "n", false)
    u.press_enter()
  end,
}
