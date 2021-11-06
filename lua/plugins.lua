local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.config/nvim/plugged')
Plug 'caenrique/nvim-toggle-terminal'
Plug('nvim-treesitter/nvim-treesitter', {['do'] = vim.fn[':TSUpdate']})  -- We recommend updating the parsers on update
Plug('neoclide/coc.nvim', { branch = 'release'}) -- Autocompletion w/ language server
Plug 'tpope/vim-dispatch' -- Allows functions to run asyncrhonously from within VIM (:Dispatch)
Plug 'tpope/vim-repeat' -- Allows plugins to repeat 
Plug 'tpope/vim-surround' -- Use cs''[encloser] (that's a double-qutation mark) to modify encloser, ysiw[encloser] to add encloser
Plug 'tpope/vim-unimpaired' -- Key mappings
Plug 'tpope/vim-eunuch' -- Rename files
Plug 'romainl/vim-cool' -- Turns off hlsearch after search is done
Plug 'vim-scripts/BufOnly.vim' -- Close all buffers but the current one
Plug 'markonm/traces.vim' -- highlights patterns and ranges for Ex commands in Command-line mode.
Plug 'djoshea/vim-autoread' -- Reloads files on change
Plug 'SirVer/ultisnips' -- Vim snippets
Plug('junegunn/fzf', {['do'] = vim.fn['fzf#install']})
Plug 'junegunn/fzf.vim'
Plug 'jtmkrueger/vim-c-cr' -- Auto indent brackets after enter
Plug 'dbakker/vim-paragraph-motion' -- Allow {  } to ignore spaces 
-- GIT
Plug 'tpope/vim-fugitive' -- Git wrapper (:G followed by git commands)
Plug 'tpope/vim-rhubarb' -- Allows :Gbrowse which opens up file in Github
Plug 'airblade/vim-gitgutter' -- Shows Git status in lefthand side
-- STYLE
Plug 'itchyny/lightline.vim' -- Adds status line at bottom of the file
Plug 'itchyny/vim-gitbranch' -- Shows branch name in lightline
Plug 'sainnhe/gruvbox-material' -- Gruvbox w/ treesitter support
-- Plug 'morhetz/gruvbox' -- Color theme
Plug 'sainnhe/sonokai' -- Color theme for vimwiki
Plug 'ryanoasis/vim-devicons' -- Icons for coc-explorer
Plug 'lambdalisue/glyph-palette.vim' -- Colors for icons
-- HTML
Plug 'adelarsq/vim-matchit' -- Allows HTML tag jumping with %
Plug 'mattn/emmet-vim' -- Enables emmet (coc-emmet provides autocomplete)
Plug 'AndrewRadev/tagalong.vim' -- Automatically changes closing tags
Plug 'alvan/vim-closetag' -- Auto-closing of HTML tags
-- REACT/JS
Plug 'pangloss/vim-javascript' -- Javascript
Plug 'leafgarland/typescript-vim' -- TypeScript syntax highlighting
Plug 'maxmellon/vim-jsx-pretty'  -- Syntax highlighting for JSX
Plug 'peitalin/vim-jsx-typescript' -- JSX Typescript syntax highlighting
Plug('styled-components/vim-styled-components', { branch = 'main' }) -- styled components library plugin
-- VUE
Plug 'posva/vim-vue'
-- OTHER
Plug 'hashivim/vim-terraform' -- Adds auto-formatting + highlighting for terraform
Plug('fatih/vim-go', { ['do'] = vim.fn[':GoUpdateBinaries']}) -- Golang development
Plug 'chr4/nginx.vim' -- Nginx configuration
Plug 'ap/vim-css-color' --Colors for CSS
Plug 'jparise/vim-graphql' -- Install linting for graphQl
Plug('iamcco/markdown-preview.nvim', { ['do'] = vim.fn['cd app && yarn install']}) -- Markdown preview server
Plug 'tpope/vim-commentary' -- gcc to comment (or 3gcc)
-- Plug 'JoosepAlviste/nvim-ts-context-commentstring'
Plug 'jiangmiao/auto-pairs' -- Auto pairing of brackets/parentheses
Plug 'neoclide/jsonc.vim' -- JSON highlighting
Plug 'vimwiki/vimwiki' -- Notetaking app
-- Vim
Plug('b0o/mapx.nvim', { branch = 'main' })
vim.call('plug#end')


