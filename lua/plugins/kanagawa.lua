local function setup()
  vim.cmd("colorscheme kanagawa")

  local kanagawa = require("kanagawa")

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
  })

  -- Make background transparent. I like semi-transparent background in the terminal.
  vim.cmd([[
    augroup user_colors
      autocmd!
      autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
    augroup END
  ]])

  -- vim.api.nvim_set_hl(0, "@tag", { fg = colors.lightBlue })
  -- vim.api.nvim_set_hl(0, "@tag.delimiter", { fg = colors.lightBlue, })
  -- vim.api.nvim_set_hl(0, "@tag.attribute", { fg = colors.sakuraPink })
  vim.cmd.hi("NonText guifg=bg")
end

return { "rebelot/kanagawa.nvim", config = setup }
