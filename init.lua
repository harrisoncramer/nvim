local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({
        'git', 'clone', '--depth', '1',
        'https://github.com/wbthomason/packer.nvim', install_path
    })
end

if vim.fn.has('macunix') then require'packer'.init({max_jobs = 4}) end
require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'neovim/nvim-lspconfig'
    use 'williamboman/nvim-lsp-installer'
    use 'onsails/lspkind-nvim'
    use 'quangnguyen30192/cmp-nvim-ultisnips'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'Olical/conjure'
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
    use {
        'lewis6991/gitsigns.nvim',
        requires = {'nvim-lua/plenary.nvim'},
        config = function() require('gitsigns').setup() end
    }
    use 'gelguy/wilder.nvim'
    use 'p00f/nvim-ts-rainbow'
    use 'shinchu/lightline-gruvbox.vim'
    use 'kyazdani42/nvim-web-devicons'
    use 'kyazdani42/nvim-tree.lua'
    use {
        'goolord/alpha-nvim',
        branch = 'main',
        requires = {'kyazdani42/nvim-web-devicons'}
    }
    use 'itchyny/vim-gitbranch'
    use {'harrisoncramer/gruvbox.nvim', requires = {'rktjmp/lush.nvim'}}
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use 'nvim-treesitter/playground'
    use 'lambdalisue/glyph-palette.vim'
    use 'posva/vim-vue'
    use 'adelarsq/vim-matchit'
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
    use {'b0o/mapx.nvim', branch = 'main'}
end)


require("settings")
require("colors")
require("mappings")
require("functions")
require("autocommands")
