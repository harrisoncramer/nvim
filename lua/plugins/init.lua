-- Any files inside the lua/plugins directory will also
-- automatically be sourced. These plugins are those that
-- do not require any configuration.
return {
  { "rcarriga/nvim-notify" },
  { "williamboman/mason.nvim" },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "davidosomething/format-ts-errors.nvim" },
    }
  },
  { "WhoIsSethDaniel/mason-tool-installer.nvim" },
  { "MunifTanjim/nui.nvim" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp-signature-help" },
  { "hrsh7th/cmp-nvim-lua",                     ft = { "lua" } },
  { "hrsh7th/cmp-nvim-lsp" },
  { "folke/neodev.nvim" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "nvim-lua/plenary.nvim" },
  { "tpope/vim-repeat" },
  { "tpope/vim-surround" },
  { "tpope/vim-rhubarb" },
  { "tpope/vim-eunuch" },
  { "guns/vim-sexp",                            ft = { "clojure" } },
  { "romainl/vim-cool" },
  { "kyazdani42/nvim-web-devicons" },
  { "lambdalisue/glyph-palette.vim" },
  { "AndrewRadev/tagalong.vim" },
  { "tpope/vim-abolish" },
  { 'djoshea/vim-autoread' },
  { "jbyuki/one-small-step-for-vimkind" },
}
