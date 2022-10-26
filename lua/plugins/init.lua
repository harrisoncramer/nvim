local u = require("functions.utils")

local setup = function(mod, remote)
  if remote == nil then
    require(mod)
  else
    local status = pcall(require, remote)
    if not status then
      print(remote .. " is not downloaded.")
      return
    else
      local local_config = require(mod)
      if type(local_config) == "table" then
        local_config.setup()
      end
    end
  end
end

local no_setup = function(mod)
  local status = pcall(require, mod)
  if not status then
    print(mod .. " is not downloaded.")
    return
  else
    require(mod).setup({})
  end
end

local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
  print("Packer installed, please exit NVIM and re-open, then run :PackerInstall")
  return
end

local packer = require("packer")

local os = u.get_os() == "Darwin" and "mac" or "linux"
local packer_options = {
  snapshot_path = vim.fn.stdpath("config") .. "/lockfiles/" .. os .. "/packer_snapshots",
}

if u.get_os() == "Darwin" then
  packer_options.max_jobs = 4
end

packer.init(packer_options)

packer.startup(function(use)
  use("wbthomason/packer.nvim")
  use("neovim/nvim-lspconfig")
  use({ "williamboman/mason.nvim" })
  use({ "williamboman/mason-lspconfig.nvim" })
  use("onsails/lspkind-nvim")
  use("hrsh7th/nvim-cmp")
  use({ "hrsh7th/cmp-nvim-lua", ft = { "lua" } })
  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-path")
  use("hrsh7th/cmp-cmdline")
  use("nvim-lua/plenary.nvim")
  use("rebelot/kanagawa.nvim") -- In colors.lua file
  use({
    "quangnguyen30192/cmp-nvim-ultisnips",
    config = setup("plugins.ultisnips"),
  })
  use({ "Olical/conjure", config = setup("plugins.conjure") })
  use({ "lukas-reineke/lsp-format.nvim" })
  use({
    "nvim-telescope/telescope.nvim",
    requires = { "nvim-lua/plenary.nvim", "junegunn/fzf" },
    config = setup("plugins.telescope", "telescope"),
  })
  use({
    "nvim-telescope/telescope-file-browser.nvim",
    requires = "nvim-telescope/telescope.nvim",
  })
  use({ 'nvim-telescope/telescope-fzf-native.nvim',
    run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
    requires = "nvim-telescope/telescope.nvim" })
  use("tpope/vim-dispatch")
  use("tpope/vim-repeat")
  use("tpope/vim-surround")
  use("tpope/vim-unimpaired")
  use("tpope/vim-rhubarb")
  use({ "kevinhwang91/nvim-bqf", requires = "junegunn/fzf.vim", config = setup("plugins.bqf", "bqf") })
  use({
    "junegunn/fzf",
    run = function()
      vim.fn["fzf#install"]()
    end,
  })
  use("tpope/vim-eunuch")
  use("tpope/vim-obsession")
  use({ "tpope/vim-sexp-mappings-for-regular-people", ft = { "clojure" } })
  use({ "guns/vim-sexp", ft = { "clojure" } })
  use({ "numToStr/Comment.nvim", config = no_setup("Comment") })
  use({ "samoshkin/vim-mergetool", before = require("plugins.mergetool") })
  use({ "numToStr/FTerm.nvim", config = setup("plugins.fterm", "FTerm") })
  use("romainl/vim-cool")
  use("SirVer/ultisnips")
  use({ "tpope/vim-fugitive", config = setup("plugins.fugitive") })
  use({ "windwp/nvim-autopairs", config = setup("plugins.autopairs", "nvim-autopairs") })
  use({
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
    config = setup("plugins.lualine", "lualine"),
  })
  use({
    "alvarosevilla95/luatab.nvim",
    config = setup("plugins/luatab", "luatab"),
    requires = "kyazdani42/nvim-web-devicons",
  })
  use({
    "lewis6991/gitsigns.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = setup("plugins.gitsigns", "gitsigns"),
  })
  use({ "gelguy/wilder.nvim", config = setup("plugins.wilder", "wilder") })
  use({ "p00f/nvim-ts-rainbow", requires = "nvim-treesitter/nvim-treesitter" })
  use({
    "nvim-treesitter/nvim-treesitter-context",
    requires = "nvim-treesitter/nvim-treesitter",
    confg = setup("plugins.treesitter-context", "treesitter-context"),
  })
  use({ "kyazdani42/nvim-web-devicons", no_setup("nvim-web-devicons") })
  use({
    "sindrets/diffview.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = setup("plugins.diffview", "diffview"),
  })
  use({ "petertriho/nvim-scrollbar", config = setup("plugins.scrollbar", "scrollbar") })
  use({ "karb94/neoscroll.nvim", config = setup("plugins.neoscroll", "neoscroll") })
  use({ "harrisoncramer/jump-tag", config = setup("plugins.jump-tag", "jump-tag") })
  use({
    "nvim-treesitter/nvim-treesitter",
    config = setup("plugins.treesitter", "nvim-treesitter"),
  })
  use({ "nvim-treesitter/playground", requires = "nvim-treesitter/nvim-treesitter" })
  use("lambdalisue/glyph-palette.vim")
  use({ "posva/vim-vue", ft = { "vue" } })
  use("andymass/vim-matchup")
  use({ "mattn/emmet-vim", ft = { "html", "vue", "javascript", "javascriptreact", "typescriptreact" } })
  use("AndrewRadev/tagalong.vim")
  use("alvan/vim-closetag")
  use("tomasiser/vim-code-dark")
  use({ "harrisoncramer/psql", config = no_setup("psql") })
  use({ "vim-test/vim-test", config = setup("plugins.vim-test") })
  use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" }, config = setup("plugins.dap", "dap") })
  use({ "kazhala/close-buffers.nvim", config = no_setup("close_buffers") })
  use({ "rcarriga/nvim-notify", config = no_setup("notify") })
  use("ton/vim-bufsurf")
  use({ "AckslD/messages.nvim", config = setup("plugins.messages", "messages") })
  use({ 'djoshea/vim-autoread' })
  use({ 'leoluz/nvim-dap-go', no_setup('dap-go') })
end)

-- See https://www.reddit.com/r/neovim/comments/y5rofg/recent_treesitter_update_borked_highlighting/
-- https://github.com/nvim-treesitter/nvim-treesitter/issues/2293#issuecomment-1279974776

-- the @punctuation.delimiter links to Delimiter (which is new)
-- Also other new upstream highlight values, so the better solution is to go through the following
-- and properly update/add the highlight for these
-- so like leave @punctuation.delimiter linking to Delimiter and style the new Delimiter
local treesitter_migrate = function()
  local map = {
    ["annotation"] = "TSAnnotation",

    ["attribute"] = "TSAttribute",

    ["boolean"] = "TSBoolean",

    ["character"] = "TSCharacter",
    ["character.special"] = "TSCharacterSpecial",

    ["comment"] = "TSComment",

    ["conditional"] = "TSConditional",

    ["constant"] = "TSConstant",
    ["constant.builtin"] = "TSConstBuiltin",
    ["constant.macro"] = "TSConstMacro",

    ["constructor"] = "TSConstructor",

    ["debug"] = "TSDebug",
    ["define"] = "TSDefine",

    ["error"] = "TSError",
    ["exception"] = "TSException",

    ["field"] = "TSField",

    ["float"] = "TSFloat",

    ["function"] = "TSFunction",
    ["function.call"] = "TSFunctionCall",
    ["function.builtin"] = "TSFuncBuiltin",
    ["function.macro"] = "TSFuncMacro",

    ["include"] = "TSInclude",

    ["keyword"] = "TSKeyword",
    ["keyword.function"] = "TSKeywordFunction",
    ["keyword.operator"] = "TSKeywordOperator",
    ["keyword.return"] = "TSKeywordReturn",

    ["label"] = "TSLabel",

    ["method"] = "TSMethod",
    ["method.call"] = "TSMethodCall",

    ["namespace"] = "TSNamespace",

    ["none"] = "TSNone",
    ["number"] = "TSNumber",

    ["operator"] = "TSOperator",

    ["parameter"] = "TSParameter",
    ["parameter.reference"] = "TSParameterReference",

    ["preproc"] = "TSPreProc",

    ["property"] = "TSProperty",

    ["punctuation.delimiter"] = "TSPunctDelimiter",
    ["punctuation.bracket"] = "TSPunctBracket",
    ["punctuation.special"] = "TSPunctSpecial",

    ["repeat"] = "TSRepeat",

    ["storageclass"] = "TSStorageClass",

    ["string"] = "TSString",
    ["string.regex"] = "TSStringRegex",
    ["string.escape"] = "TSStringEscape",
    ["string.special"] = "TSStringSpecial",

    ["symbol"] = "TSSymbol",

    ["tag"] = "TSTag",
    ["tag.attribute"] = "TSTagAttribute",
    ["tag.delimiter"] = "TSTagDelimiter",

    ["text"] = "TSText",
    ["text.strong"] = "TSStrong",
    ["text.emphasis"] = "TSEmphasis",
    ["text.underline"] = "TSUnderline",
    ["text.strike"] = "TSStrike",
    ["text.title"] = "TSTitle",
    ["text.literal"] = "TSLiteral",
    ["text.uri"] = "TSURI",
    ["text.math"] = "TSMath",
    ["text.reference"] = "TSTextReference",
    ["text.environment"] = "TSEnvironment",
    ["text.environment.name"] = "TSEnvironmentName",

    ["text.note"] = "TSNote",
    ["text.warning"] = "TSWarning",
    ["text.danger"] = "TSDanger",

    ["todo"] = "TSTodo",

    ["type"] = "TSType",
    ["type.builtin"] = "TSTypeBuiltin",
    ["type.qualifier"] = "TSTypeQualifier",
    ["type.definition"] = "TSTypeDefinition",

    ["variable"] = "TSVariable",
    ["variable.builtin"] = "TSVariableBuiltin",
  }

  for capture, hlgroup in pairs(map) do
    vim.api.nvim_set_hl(0, "@" .. capture, { link = hlgroup, default = true })
  end

  local defaults = {
    TSNone = { default = true },
    TSPunctDelimiter = { link = "Delimiter", default = true },
    TSPunctBracket = { link = "Delimiter", default = true },
    TSPunctSpecial = { link = "Delimiter", default = true },

    TSConstant = { link = "Constant", default = true },
    TSConstBuiltin = { link = "Special", default = true },
    TSConstMacro = { link = "Define", default = true },
    TSString = { link = "String", default = true },
    TSStringRegex = { link = "String", default = true },
    TSStringEscape = { link = "SpecialChar", default = true },
    TSStringSpecial = { link = "SpecialChar", default = true },
    TSCharacter = { link = "Character", default = true },
    TSCharacterSpecial = { link = "SpecialChar", default = true },
    TSNumber = { link = "Number", default = true },
    TSBoolean = { link = "Boolean", default = true },
    TSFloat = { link = "Float", default = true },

    TSFunction = { link = "Function", default = true },
    TSFunctionCall = { link = "TSFunction", default = true },
    TSFuncBuiltin = { link = "Special", default = true },
    TSFuncMacro = { link = "Macro", default = true },
    TSParameter = { link = "Identifier", default = true },
    TSParameterReference = { link = "TSParameter", default = true },
    TSMethod = { link = "Function", default = true },
    TSMethodCall = { link = "TSMethod", default = true },
    TSField = { link = "Identifier", default = true },
    TSProperty = { link = "Identifier", default = true },
    TSConstructor = { link = "Special", default = true },
    TSAnnotation = { link = "PreProc", default = true },
    TSAttribute = { link = "PreProc", default = true },
    TSNamespace = { link = "Include", default = true },
    TSSymbol = { link = "Identifier", default = true },

    TSConditional = { link = "Conditional", default = true },
    TSRepeat = { link = "Repeat", default = true },
    TSLabel = { link = "Label", default = true },
    TSOperator = { link = "Operator", default = true },
    TSKeyword = { link = "Keyword", default = true },
    TSKeywordFunction = { link = "Keyword", default = true },
    TSKeywordOperator = { link = "TSOperator", default = true },
    TSKeywordReturn = { link = "TSKeyword", default = true },
    TSException = { link = "Exception", default = true },
    TSDebug = { link = "Debug", default = true },
    TSDefine = { link = "Define", default = true },
    TSPreProc = { link = "PreProc", default = true },
    TSStorageClass = { link = "StorageClass", default = true },

    TSTodo = { link = "Todo", default = true },

    TSType = { link = "Type", default = true },
    TSTypeBuiltin = { link = "Type", default = true },
    TSTypeQualifier = { link = "Type", default = true },
    TSTypeDefinition = { link = "Typedef", default = true },

    TSInclude = { link = "Include", default = true },

    TSVariableBuiltin = { link = "Special", default = true },

    TSText = { link = "TSNone", default = true },
    TSStrong = { bold = true, default = true },
    TSEmphasis = { italic = true, default = true },
    TSUnderline = { underline = true },
    TSStrike = { strikethrough = true },

    TSMath = { link = "Special", default = true },
    TSTextReference = { link = "Constant", default = true },
    TSEnvironment = { link = "Macro", default = true },
    TSEnvironmentName = { link = "Type", default = true },
    TSTitle = { link = "Title", default = true },
    TSLiteral = { link = "String", default = true },
    TSURI = { link = "Underlined", default = true },

    TSComment = { link = "Comment", default = true },
    TSNote = { link = "SpecialComment", default = true },
    TSWarning = { link = "Todo", default = true },
    TSDanger = { link = "WarningMsg", default = true },

    TSTag = { link = "Label", default = true },
    TSTagDelimiter = { link = "Delimiter", default = true },
    TSTagAttribute = { link = "TSProperty", default = true },
  }

  for group, val in pairs(defaults) do
    vim.api.nvim_set_hl(0, group, val)
  end
end

treesitter_migrate()
