-- Utility function for plugin settings
local remap = require("functions").remap
local setup = function(mod)
	require(mod).setup(remap)
end

-- Ensure that packer is installed w/ git clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
if vim.fn.has("macunix") then
	require("packer").init({ max_jobs = 4 })
end
require("packer").startup({
	function()
		use("wbthomason/packer.nvim")
		use("neovim/nvim-lspconfig")
		use("williamboman/nvim-lsp-installer")
		use("onsails/lspkind-nvim")
		use("hrsh7th/nvim-cmp")
		use({ "hrsh7th/cmp-nvim-lua", ft = { "lua" } })
		use("hrsh7th/cmp-nvim-lsp")
		use("hrsh7th/cmp-buffer")
		use("hrsh7th/cmp-path")
		use("hrsh7th/cmp-cmdline")
		use("nvim-lua/plenary.nvim")
		use({
			"quangnguyen30192/cmp-nvim-ultisnips",
			config = setup("plugins.ultisnips"),
		})
		use({ "Olical/conjure", config = setup("plugins.conjure") })
		use("jose-elias-alvarez/null-ls.nvim")
		use({ "phaazon/hop.nvim", branch = "v1", config = setup("plugins.hop") })
		use({
			"nvim-telescope/telescope.nvim",
			requires = { { "nvim-lua/plenary.nvim" } },
			config = setup("plugins.telescope"),
		})
		use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
		use("tpope/vim-dispatch")
		use("tpope/vim-repeat")
		use("tpope/vim-surround")
		use("tpope/vim-unimpaired")
		use("tpope/vim-eunuch")
		use({ "tpope/vim-sexp-mappings-for-regular-people", ft = { "clojure" } })
		use({ "guns/vim-sexp", ft = { "clojure" } })
		use({
			"numToStr/Comment.nvim",
			config = function()
				require("Comment").setup()
			end,
		})
		use({ "samoshkin/vim-mergetool", before = require("plugins.mergetool") })
		use({ "numToStr/FTerm.nvim", config = setup("plugins.fterm") })
		use("romainl/vim-cool")
		use("tpope/vim-rhubarb")
		use("ellisonleao/glow.nvim")
		use("vim-scripts/BufOnly.vim")
		use("markonm/traces.vim")
		use("djoshea/vim-autoread")
		use("SirVer/ultisnips")
		use("jtmkrueger/vim-c-cr")
		use({ "tpope/vim-fugitive", config = setup("plugins.fugitive") })
		use({ "TimUntersberger/neogit", requires = "nvim-lua/plenary.nvim", config = setup("plugins.neogit") })
		use({ "windwp/nvim-autopairs", config = setup("plugins.autopairs") })
		use({ "prettier/vim-prettier", run = "npm install" })
		use({
			"nvim-lualine/lualine.nvim",
			requires = { "kyazdani42/nvim-web-devicons", opt = true },
			config = setup("plugins.lualine"),
		})
		use({
			"lewis6991/gitsigns.nvim",
			requires = { "nvim-lua/plenary.nvim" },
			config = setup("plugins.gitsigns"),
		})
		use({ "gelguy/wilder.nvim", config = setup("plugins.wilder") })
		use("p00f/nvim-ts-rainbow")
		use("kyazdani42/nvim-web-devicons")
		use({ "kyazdani42/nvim-tree.lua", config = setup("plugins.nvim_tree") })
		use({
			"sindrets/diffview.nvim",
			requires = "nvim-lua/plenary.nvim",
			config = setup("plugins.diffview"),
		})
		use({
			"goolord/alpha-nvim",
			branch = "main",
			requires = { "kyazdani42/nvim-web-devicons" },
			config = setup("plugins.alpha"),
		})
		use({
			"filipdutescu/renamer.nvim",
			branch = "master",
			requires = { { "nvim-lua/plenary.nvim" } },
		})
		use({
			"akinsho/bufferline.nvim",
			requires = "kyazdani42/nvim-web-devicons",
			config = setup("plugins.bufferline"),
		})
		use("itchyny/vim-gitbranch")
		use({ "harrisoncramer/gruvbox.nvim", requires = { "rktjmp/lush.nvim" } })
		use({ "harrisoncramer/jump-tag", config = setup("plugins.jump-tag") })
		use("rebelot/kanagawa.nvim")
		use({
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			config = setup("plugins.treesitter"),
		})
		use("nvim-treesitter/playground")
		use("lambdalisue/glyph-palette.vim")
		use("posva/vim-vue")
		use("andymass/vim-matchup")
		use("mattn/emmet-vim")
		use("AndrewRadev/tagalong.vim")
		use("alvan/vim-closetag")
		use("hashivim/vim-terraform")
		use("ap/vim-css-color")
		use("jparise/vim-graphql")
		use("vimwiki/vimwiki")
	end,
	config = {
		display = {
			open_fn = require("packer.util").float,
		},
	},
})
