""""""""""""""""""
" SETTINGS 
"""""""""""""""""" 
" Set leader to comma/space key
:let mapleader=" "
nnoremap <SPACE> <Nop>
"Mouse support active. Alt click
set mouse=a
" Set relative line numbers for jumping
set relativenumber
" Number of current line
set number
" Turn on clipboard across panes for tmux
set clipboard+=unnamedplus
" Set substitute/replace command to automatically use global flag
set gdefault
" Do not allow line wraping
set nowrap
" Start scrolling when you're 15 away from bottom (and side)
set scrolloff=15
set sidescrolloff=35
" Keep column for linting always on 
set signcolumn=yes
" Search settings 
set hlsearch
set incsearch
hi IncSearch ctermfg=51 ctermbg=0 gui=bold guifg=#0096FF guibg=#0096FF
" Allow folding
:setlocal foldmethod=syntax
set foldlevelstart=99
" Allow undo-ing even after save file
set undofile                 "turn on the feature  
set undodir=$HOME/.vim/undo  "directory where the undo files will be stored
" Create splits vertically by default
:set diffopt+=vertical
" Set tab spacing to be 2 characters wide
set tabstop=2
" On pressing tab, insert 2 spaces
set expandtab
" Show existing tab with 2 spaces width
set softtabstop=2
" When indenting with '>', use 2 spaces width
set shiftwidth=2
" Set no swap files
set noswapfile
set nobackup
" And use undodir instead
set undodir=~/.vim/undodir
set undofile
" Carry over current indentation to next line
set autoindent
" Set indent intelligently
set smartindent
set cindent 
" Hide 'No write since last change' error on switching buffers Keeps buffer open in the background. 
set hidden
" Control searching. Ignore case during search, except if it includes a capital letter
set ignorecase 
set smartcase
" Allow backspace in insert mode
set backspace=indent,eol,start
" Set tab to wildcharm (for completion of suggestions)
" set wildcharm=<tab>
