local function setup()
  local kanagawa = require("kanagawa")
  local colorMap = require("colorscheme")

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
    overrides = {},
  })

  vim.cmd.colorscheme('kanagawa')

  vim.cmd.hi("NonText guifg=bg")
  vim.cmd.hi("IncSearch guifg=White guibg=" .. colorMap.samuraiRed)
  vim.cmd.hi("Search guifg=White guibg=" .. colorMap.autumnRed)

end

return { "rebelot/kanagawa.nvim", config = setup }
