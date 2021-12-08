-- Key bindings can be changed, see below
vim.cmd[[
  call wilder#setup({'modes': [':', '/', '?']})
  call wilder#set_option('renderer', wilder#popupmenu_renderer({
      \ 'highlighter': wilder#basic_highlighter(),
      \ }))

  call wilder#setup({
    \ 'modes': [':'],
    \ 'next_key': '<C-n>',
    \ 'previous_key': '<C-p>',
    \ 'accept_key': '<Down>',
    \ 'reject_key': '<Up>',
  \ })
]]

