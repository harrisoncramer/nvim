local function setup()
  local default_colors = require("kanagawa.colors").setup()
  local kanagawa = require("kanagawa")

  local strongHighlight =  "#fa7af6"

  kanagawa.setup({
    undercurl = true, -- enable undercurls
    commentStyle = {
      italic = true,
    },
    functionStyle = {},
    keywordStyle = {
      italic = true,
    },
    statementStyle = {},
    typeStyle = {},
    variablebuiltinStyle = {
      italic = true,
    },
    specialReturn = true, -- special highlight for the return keyword
    specialException = true, -- special highlight for exception handling keywords
    transparent = false, -- do not set background color
    colors = {},
    overrides = {
      IncSearch = { fg = "black", bg = strongHighlight, underline = true, bold = true },
      Search = { fg = "black", bg = default_colors.oniViolet },
      Substitute = { fg = "black", fg = strongHighlight },
    },
  })

  vim.cmd.colorscheme('kanagawa')
  vim.api.nvim_set_hl(0, "@tag", { fg = default_colors.lightBlue })
  vim.api.nvim_set_hl(0, "@tag.delimiter", { fg = default_colors.lightBlue, })
  vim.api.nvim_set_hl(0, "@tag.attribute", { fg = default_colors.sakuraPink })
  vim.cmd.hi("NonText guifg=bg")

end

return { "rebelot/kanagawa.nvim", config = setup }
