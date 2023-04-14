-- set.leaders
vim.cmd([[ nnoremap <Space> <NOP>]])
vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.api.nvim_set_option('shm', vim.o.shm .. 'I')

vim.g.wildmenu = true
vim.g.wildignore = "**/node_modules/**"
-- update time for plugins (speed when they act)
vim.opt.updatetime = 300
-- set.relative line numbers for jumping
vim.opt.relativenumber = true
-- Number of current line
vim.opt.number = true
-- Set regular expression engine
vim.opt.regexpengine = 1
-- Turn on clipboard across panes for tmux
vim.opt.clipboard = 'unnamedplus'
-- set substitute/replace command to automatically use global flag
vim.opt.gdefault = true
-- Do not allow line wrapping
vim.opt.wrap = false
-- Start scrolling when you're 15 away from bottom (and side)
vim.opt.scrolloff = 15
vim.opt.sidescrolloff = 35
-- Keep column for linting always on
vim.opt.signcolumn = "yes"
-- Search settings
vim.opt.hlsearch = true
vim.opt.incsearch = true
-- set no swap files
vim.opt.swapfile = false
vim.opt.backup = false
-- And use undodir instead
-- Allow undo-ing even after save file
vim.opt.undodir = vim.fn.stdpath("config") .. "/.undo"
vim.opt.undofile = true
-- Hide 'No write since last change' error on switching buffers Keeps buffer open in the background.
vim.opt.hidden = true
-- Control searching. Ignore case during search, except if it includes a capital letter
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.backspace = "indent,eol,start"

-- Don't break words in LSP docs
vim.api.nvim_command('set wrap linebreak nolist')

-- Colors
vim.opt.termguicolors = true

-- Indenting
vim.opt.shiftwidth = 2
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.cindent = true
vim.opt.tabstop = 2
vim.opt.expandtab = true

-- Plugins
vim.g.closetag_filenames = "*.html,*.jsx,*.js,*.tsx,*.vue"
vim.g.vimwiki_map_prefix = "<Leader><F13>"
vim.g.matchup_matchparen_offscreen = { method = "popup" }

-- Diffs (no whitespace and vertical by default)
vim.opt.diffopt = "vertical,iwhite"
vim.opt.diffexpr = ""

vim.o.ls = 0
vim.o.ch = 0

vim.filetype.add({ extension = { mdx = 'mdx' } })
