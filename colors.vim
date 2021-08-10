""""""""""""""""""
" COLOR THEME
"""""""""""""""""" 
" Set color theme (loaded from plugin)
let g:gruvbox_italic=1
colorscheme gruvbox
set background=dark    " Setting dark mode
let g:gruvbox_contrast_dark = 'medium'

""""""""""""""""""
" DIFF MODE COLORS
"""""""""""""""""" 
hi DiffText   cterm=none ctermfg=Black ctermbg=Red gui=none guifg=Black guibg=Red
hi DiffChange cterm=none ctermfg=Black ctermbg=LightMagenta gui=none guifg=Black guibg=LightMagenta
