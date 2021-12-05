local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require('packer').startup(function()
  use 'wbthomason/packer.nvim' -- Let packer manage itself
  -- LANGUAGE SERVER --
  use 'hrsh7th/cmp-nvim-lsp' -- Completion
  use 'neovim/nvim-lspconfig' -- Configuring LSPs
  use 'williamboman/nvim-lsp-installer' -- For installing language servers
  use 'quangnguyen30192/cmp-nvim-ultisnips'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use 'Olical/conjure'
  use {
    'phaazon/hop.nvim',
    branch = 'v1', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  }
  -- CORE --
  use { 'nvim-telescope/telescope.nvim', requires = { {'nvim-lua/plenary.nvim'} } }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use 'tpope/vim-dispatch' -- Allows functions to run asyncrhonously from within VIM (:Dispatch)
  use 'tpope/vim-repeat' -- Allows plugins to repeat
  use 'tpope/vim-surround' -- Use cs''[encloser] (that's a double-qutation mark) to modify encloser, ysiw[encloser] to add encloser
  use 'tpope/vim-unimpaired' -- Key mappings
  use 'tpope/vim-eunuch' -- Rename files
  use {
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup()
    end
  }
  use 'akinsho/toggleterm.nvim' -- Toggling the terminal
  use 'romainl/vim-cool' -- Turns off hlsearch after search is done
  use 'tpope/vim-rhubarb' -- Allows :Gbrowse which opens up file in Github
  use 'vim-scripts/BufOnly.vim' -- Close all buffers but the current one
  use 'markonm/traces.vim' -- highlights patterns and ranges for Ex commands in Command-line mode.
  use 'djoshea/vim-autoread' -- Reloads files on change
  use 'SirVer/ultisnips' -- Vim snippets
  use 'jtmkrueger/vim-c-cr' -- Auto indent brackets after enter
  use 'tpope/vim-fugitive' -- Git wrapper (:G followed by git commands)
  use 'jiangmiao/auto-pairs' -- Auto pairing of brackets/parentheses
  use {
    'prettier/vim-prettier',
    run = 'npm install',
  }
  -- VIEW --
  use {
    'nvim-lualine/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true}
  }
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('gitsigns').setup()
    end
  }
  use 'p00f/nvim-ts-rainbow' -- Rainbow brackets for Clojure
  use 'shinchu/lightline-gruvbox.vim' -- Lightline color scheme
  use 'kyazdani42/nvim-web-devicons' -- Icons
  use 'kyazdani42/nvim-tree.lua' -- Tree
  use { 'goolord/alpha-nvim', branch = 'main', requires = { 'kyazdani42/nvim-web-devicons' } }
  use 'itchyny/vim-gitbranch' -- Shows branch name in lightline
  use { 'harrisoncramer/gruvbox.nvim', requires = { 'rktjmp/lush.nvim' }}
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'nvim-treesitter/playground' -- Playground
  use 'lambdalisue/glyph-palette.vim' -- Colors for icons
  -- LANGUAGES --
  use 'posva/vim-vue'
  use 'adelarsq/vim-matchit' -- Allows HTML tag jumping with %
  use 'mattn/emmet-vim' -- Enables emmet (coc-emmet provides autocomplete)
  use 'AndrewRadev/tagalong.vim' -- Automatically changes closing tags
  use 'alvan/vim-closetag' -- Auto-closing of HTML tags
  use 'hashivim/vim-terraform' -- Adds auto-formatting + highlighting for terraform
  use 'ap/vim-css-color' --Colors for CSS
  use 'jparise/vim-graphql' -- Install linting for graphQl
  use 'vimwiki/vimwiki' -- Notetaking app
  use { 'b0o/mapx.nvim', branch = 'main' }
end)

-- Main Imports
require("settings")
require("colors")
require("mappings")
require("functions")
require("autocommands")

vim.g.gruvbox_sign_column = 'white'
