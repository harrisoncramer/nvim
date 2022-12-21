local u = require("functions.utils")

-- Require the plugin, and instead of calling it's setup method,
-- require another module at the given path and call THAT module's
-- setup function. Used to customize the plugin.
local custom = function(remote, config)
  if remote == nil then
    local local_config_ok = pcall(require, config)
    if not local_config_ok then
      print(config .. " configuration file not found.")
    end
  else
    local status = pcall(require, remote)
    if not status then
      print(remote .. " is not downloaded.")
      return
    end
    local local_config_ok = pcall(require, config)
    if not local_config_ok then
      print(remote .. " is not configured.")
    end
  end
end

-- Simply requires the module and calls it's setup method, if it exists
local default = function(mod)
  local status, m = pcall(require, mod)
  if not status then
    print(mod .. " is not downloaded.")
    return
  else
    if type(m.setup) == "function" then
      m.setup()
    end
  end
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)


vim.keymap.set("n", "<leader>vp", function()
  vim.cmd.Lazy()
end)

local plugins = {
  { "rcarriga/nvim-notify", config = custom("notify", "plugins.notify") },
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason-lspconfig.nvim" },
  { "harrisoncramer/mason-nvim-dap.nvim" },
  { "williamboman/mason.nvim", default("mason") },
  { "onsails/lspkind-nvim" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp-signature-help" },
  { "hrsh7th/cmp-nvim-lua", ft = { "lua" } },
  { "hrsh7th/cmp-nvim-lsp" },
  { "folke/neodev.nvim" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "nvim-lua/plenary.nvim" },
  { "rebelot/kanagawa.nvim" }, -- In colors.lua file
  { "quangnguyen30192/cmp-nvim-ultisnips", config = custom(nil, "plugins.ultisnips") },
  { "lukas-reineke/lsp-format.nvim" },
  {
    "nvim-telescope/telescope.nvim",
    requires = { "nvim-lua/plenary.nvim", "junegunn/fzf" },
    config = custom("telescope", "plugins.telescope"),
  },
  { "nvim-telescope/telescope-file-browser.nvim", requires = "nvim-telescope/telescope.nvim" },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
    requires = "nvim-telescope/telescope.nvim"
  },
  { "junegunn/fzf", run = function() vim.fn["fzf#install"]() end },
  { "kevinhwang91/nvim-bqf", requires = "junegunn/fzf.vim", config = custom("bqf", "plugins.bqf") },
  { "tpope/vim-dispatch" },
  { "tpope/vim-repeat" },
  { "tpope/vim-surround" },
  { "tpope/vim-unimpaired" },
  { "tpope/vim-rhubarb" },
  { "tpope/vim-eunuch" },
  { "tpope/vim-obsession" },
  { "tpope/vim-sexp-mappings-for-regular-people", ft = { "clojure" } },
  { "guns/vim-sexp", ft = { "clojure" } },
  { "Olical/conjure", ft = { "clojure" }, config = custom(nil, "plugins.conjure") },
  { "numToStr/Comment.nvim", config = default("Comment") },
  { "numToStr/FTerm.nvim", config = custom("FTerm", "plugins.fterm") },
  { "romainl/vim-cool" },
  { "SirVer/ultisnips" },
  { "tpope/vim-fugitive", config = custom(nil, "plugins.fugitive") },
  { "windwp/nvim-autopairs", config = custom("nvim-autopairs", "plugins.autopairs") },
  {
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
    config = custom("lualine", "plugins.lualine")
  },
  {
    "alvarosevilla95/luatab.nvim",
    config = custom("plugins/luatab", "luatab"),
    requires = "kyazdani42/nvim-web-devicons",
  },
  {
    "lewis6991/gitsigns.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = custom("gitsigns", "plugins.gitsigns"),
  },
  { "gelguy/wilder.nvim", config = custom("wilder", "plugins.wilder") },
  {
    "nvim-treesitter/nvim-treesitter",
    config = custom("plugins.treesitter", "nvim-treesitter"),
  },
  { "p00f/nvim-ts-rainbow", requires = "nvim-treesitter/nvim-treesitter" },
  {
    "nvim-treesitter/nvim-treesitter-context",
    requires = "nvim-treesitter/nvim-treesitter",
    confg = custom("treesitter-context", "plugins.treesitter-context"),
  },
  { "kyazdani42/nvim-web-devicons", default("nvim-web-devicons") },
  {
    "sindrets/diffview.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = custom("diffview", "plugins.diffview"),
  },
  { "petertriho/nvim-scrollbar", config = custom("scrollbar", "plugins.scrollbar") },
  { "harrisoncramer/jump-tag", config = custom("jump-tag", "plugins.jump-tag") },
  { "lambdalisue/glyph-palette.vim" },
  { "posva/vim-vue", ft = { "vue" } },
  { "AndrewRadev/tagalong.vim" },
  { "windwp/nvim-ts-autotag" },
  { "rcarriga/nvim-notify", config = custom("notify", "plugins.notify") },
  { "AckslD/messages.nvim", config = custom("messages", "plugins.messages") },
  { 'djoshea/vim-autoread' },
  { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" }, config = custom("dap", "plugins.dap") }, -- Visual Studio Code Debugger Requires Special Installation
  { "mxsdev/nvim-dap-vscode-js", requires = { "mfussenegger/nvim-dap" } },
  {
    "nvim-neotest/neotest",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "marilari88/neotest-vitest",
      "nvim-neotest/neotest-go",
    },
    custom("neotest", "plugins.neotest")
  },
  { 'ggandor/leap.nvim', custom("leap", "plugins.leap") },
}

require("lazy").setup(plugins)
