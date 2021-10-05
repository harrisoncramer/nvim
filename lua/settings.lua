--
-- SETTINGS 
-- 

-- set.leader to comma/space key
vim.g.mapleader = " "
-- nnoremap <SPACE> <Nop>
--Mouse support active. Alt click
vim.opt.mouse = 'a'
-- set.relative line numbers for jumping
vim.opt.relativenumber = true
-- Number of current line
vim.opt.number = true
-- Turn on clipboard across panes for tmux
-- vim.opt.clipboard += 'unnamedplus'
-- set substitute/replace command to automatically use global flag
vim.opt.gdefault = true
-- Do not allow line wraping
vim.opt.wrap = false
-- Start scrolling when you're 15 away from bottom (and side)
vim.opt.scrolloff = 15
vim.opt.sidescrolloff = 35
-- Keep column for linting always on 
vim.opt.signcolumn = 'yes'
-- Search settings 
vim.opt.hlsearch = true
vim.opt.incsearch = true
-- hi IncSearch ctermfg=51 ctermbg=0 gui=bold guifg=#0096FF guibg=#0096FF
-- Allow folding
vim.opt.foldmethod = 'syntax'
vim.opt.foldlevelstart = 99
-- Create splits vertically by default
vim.opt.diffopt = 'vertical'
-- set tab spacing to be 2 characters wide
vim.opt.tabstop = 2
-- On pressing tab, insert 2 spaces
vim.opt.expandtab = true
-- Show existing tab with 2 spaces width
vim.opt.softtabstop = 2
-- When indenting with '>', use 2 spaces width
vim.opt.shiftwidth = 2
-- set no swap files
vim.opt.swapfile = false
vim.opt.backup = false
-- And use undodir instead
-- Allow undo-ing even after save file
vim.opt.undodir = vim.fn.stdpath('config') .. '/.undo'
vim.opt.undofile = true

-- Carry over current indentation to next line
vim.opt.autoindent = true
-- set indent intelligently
vim.opt.smartindent = true
vim.opt.cindent = true
-- Hide 'No write since last change' error on switching buffers Keeps buffer open in the background.  
vim.opt.hidden = true
-- Control searching. Ignore case during search, except if it includes a capital letter
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.backspace = 'indent,eol,start'
-- set tab to wildcharm (for completion of suggestions)
-- set wildcharm = <tab>
