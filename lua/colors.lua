vim.cmd('set termguicolors " this variable must be enabled for colors to be applied properly')
vim.cmd('colorscheme gruvbox')
vim.cmd[[
  :hi NonText guifg=bg
  :set signcolumn=yes
]]
require'nvim-web-devicons'.setup{}
