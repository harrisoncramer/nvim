local vim = vim
local execute = vim.api.nvim_command
local fn = vim.fn

local setup = function (mod)
  local module = require(mod)
  module.setup()
end

-- Ensure that packer is installed w/ git clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
if vim.fn.has('macunix') then require'packer'.init({max_jobs = 4}) end
require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'neovim/nvim-lspconfig'
    use 'williamboman/nvim-lsp-installer'
    use 'onsails/lspkind-nvim'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lua'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'quangnguyen30192/cmp-nvim-ultisnips'
    use 'Olical/conjure'
    use 'jose-elias-alvarez/null-ls.nvim'
    use {
        'phaazon/hop.nvim',
        branch = 'v1',
        config = function()
            require'hop'.setup {keys = 'etovxqpdygfblzhckisuran'}
        end
    }
    use {
        'nvim-telescope/telescope.nvim',
        requires = {{'nvim-lua/plenary.nvim'}}
    }
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}
    use 'tpope/vim-dispatch'
    use 'tpope/vim-repeat'
    use 'tpope/vim-surround'
    use 'tpope/vim-unimpaired'
    use 'tpope/vim-eunuch'
    use {
        'numToStr/Comment.nvim',
        config = function() require('Comment').setup() end
    }
    use 'samoshkin/vim-mergetool'
    use "numToStr/FTerm.nvim"
    use 'romainl/vim-cool'
    use 'tpope/vim-rhubarb'
    use 'vim-scripts/BufOnly.vim'
    use 'markonm/traces.vim'
    use 'djoshea/vim-autoread'
    use 'SirVer/ultisnips'
    use 'jtmkrueger/vim-c-cr'
    use 'tpope/vim-fugitive'
    use 'jiangmiao/auto-pairs'
    use {'prettier/vim-prettier', run = 'npm install'}
    use {
        'nvim-lualine/lualine.nvim',
        requires = {'kyazdani42/nvim-web-devicons', opt = true}
    }
    use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}}
    use 'gelguy/wilder.nvim'
    use 'p00f/nvim-ts-rainbow'
    use 'shinchu/lightline-gruvbox.vim'
    use 'kyazdani42/nvim-web-devicons'
    use 'kyazdani42/nvim-tree.lua'
    use {'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim'}
    use {
        'goolord/alpha-nvim',
        branch = 'main',
        requires = {'kyazdani42/nvim-web-devicons'},
        before = setup("plugins.alpha")
    }
    use {
        'filipdutescu/renamer.nvim',
        branch = 'master',
        requires = {{'nvim-lua/plenary.nvim'}}
    }
    use {'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons'}
    use 'itchyny/vim-gitbranch'
    use {'harrisoncramer/gruvbox.nvim', requires = {'rktjmp/lush.nvim'}}
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use 'nvim-treesitter/playground'
    use 'lambdalisue/glyph-palette.vim'
    use 'posva/vim-vue'
    use 'andymass/vim-matchup'
    use 'mattn/emmet-vim'
    use 'AndrewRadev/tagalong.vim'
    use 'alvan/vim-closetag'
    use 'hashivim/vim-terraform'
    use 'ap/vim-css-color'
    use 'jparise/vim-graphql'
    use 'vimwiki/vimwiki'
    use {
        "mhartington/formatter.nvim",
        config = function()
            require("formatter").setup({
                filetype = {

                    lua = {
                        function()
                            return {exe = "lua-format", stdin = true}
                        end
                    }
                }
            })
        end
    }
end)

-- Remapping function.
_G.remap = function(key)
    local opts = {noremap = true, silent = true}
    for i, v in pairs(key) do if type(i) == 'string' then opts[i] = v end end
    local buffer = opts.buffer
    opts.buffer = nil
    if buffer then
        vim.api.nvim_buf_set_keymap(0, key[1], key[2], key[3], opts)
    else
        vim.api.nvim_set_keymap(key[1], key[2], key[3], opts)
    end
end

require("settings")
require("colors")
require("mappings")
require("functions")
require("autocommands")
require("lsp")
