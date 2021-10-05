""""""""""""""""""
" COLOR THEME
"""""""""""""""""" 
if has('termguicolors')
  set termguicolors
endif

let g:gruvbox_material_enable_italic = 1
let g:gruvbox_material_ui_contrast = 'low'
let g:gruvbox_material_background = 'medium'
let g:gruvbox_material_enable_bold = 1
let g:gruvbox_material_better_performance = 1


colorscheme gruvbox-material


""""""""""""""""""
" DIFF MODE COLORS
"""""""""""""""""" 
hi DiffText   cterm=none ctermfg=Black ctermbg=Red gui=none guifg=Black guibg=Red
hi DiffChange cterm=none ctermfg=Black ctermbg=LightMagenta gui=none guifg=Black guibg=LightMagenta

hi x205_HotPink ctermfg=205 guifg=#ff5faf "rgb=255,95,175
hi x206_HotPink ctermfg=206 guifg=#ff5fd7 "rgb=255,95,215
hi x207_MediumOrchid1 ctermfg=207 guifg=#ff5fff "rgb=255,95,255
hi x161_DeepPink3 ctermfg=161 guifg=#d7005f "rgb=215,0,95
hi x095_LightPink4 ctermfg=95 guifg=#875f5f "rgb=135,95,95
hi x062_SlateBlue3 ctermfg=62 guifg=#5f5fd7 "rgb=95,95,215
hi x074_SkyBlue3 ctermfg=74 guifg=#5fafd7 "rgb=95,175,215
hi x071_DarkSeaGreen4 ctermfg=71 guifg=#5faf5f "rgb=95,175,95
hi x029_SpringGreen4 ctermfg=29 guifg=#00875f "rgb=0,135,95

hi link VimwikiHeader1 x206_HotPink
hi link VimwikiHeader2 x074_SkyBlue3
hi link VimwikiHeader3 x071_DarkSeaGreen4
hi link VimwikiHeader4 x029_SpringGreen4
