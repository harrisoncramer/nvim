return require('packer').startup(function()
  use {
    'goolord/alpha-nvim',
    branch = 'main',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function ()
        require'alpha'.setup(require'alpha.themes.startify'.opts)
    end
  }
  use 'ryanoasis/vim-devicons' -- Devicons for CoC
  use 'Pocco81/AutoSave.nvim' -- Auto saves files
  use 'tpope/vim-dispatch' -- Allows functions to run asyncrhonously from within VIM (:Dispatch)
  use 'tpope/vim-repeat' -- Allows plugins to repeat 
  use 'tpope/vim-surround' -- Use cs''[encloser] (that's a double-qutation mark) to modify encloser, ysiw[encloser] to add encloser
  use 'tpope/vim-unimpaired' -- Key mappings
  use 'tpope/vim-eunuch' -- Rename files
  use 'romainl/vim-cool' -- Turns off hlsearch after search is done
  use 'tpope/vim-rhubarb' -- Allows :Gbrowse which opens up file in Github
  use 'tpope/vim-rhubarb' -- Allows :Gbrowse which opens up file in Github
  use 'vim-scripts/BufOnly.vim' -- Close all buffers but the current one
  use 'markonm/traces.vim' -- highlights patterns and ranges for Ex commands in Command-line mode.
  use 'djoshea/vim-autoread' -- Reloads files on change
  use 'SirVer/ultisnips' -- Vim snippets
  use 'junegunn/fzf.vim'
  use 'jtmkrueger/vim-c-cr' -- Auto indent brackets after enter
  use 'tpope/vim-fugitive' -- Git wrapper (:G followed by git commands)
  use 'airblade/vim-gitgutter' -- Shows Git status in lefthand side
  use 'itchyny/lightline.vim' -- Adds status line at bottom of the file
  use 'goolord/alpha-nvim' -- Adds startup screen
  use 'itchyny/vim-gitbranch' -- Shows branch name in lightline
  use 'sainnhe/gruvbox-material' -- Gruvbox w/ treesitter support
  use 'sainnhe/sonokai' -- Color theme for vimwiki
  use 'lambdalisue/glyph-palette.vim' -- Colors for icons
  use 'adelarsq/vim-matchit' -- Allows HTML tag jumping with %
  use 'mattn/emmet-vim' -- Enables emmet (coc-emmet provides autocomplete)
  use 'AndrewRadev/tagalong.vim' -- Automatically changes closing tags
  use 'alvan/vim-closetag' -- Auto-closing of HTML tags
  use 'posva/vim-vue'
  use 'hashivim/vim-terraform' -- Adds auto-formatting + highlighting for terraform
  use 'ap/vim-css-color' --Colors for CSS
  use 'jparise/vim-graphql' -- Install linting for graphQl
  use 'tpope/vim-commentary' -- gcc to comment (or 3gcc)
  use 'jiangmiao/auto-pairs' -- Auto pairing of brackets/parentheses
  use 'vimwiki/vimwiki' -- Notetaking app
  use 'akinsho/toggleterm.nvim' 
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
