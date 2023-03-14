return {
  "rebelot/kanagawa.nvim",
  config = function()
    local kanagawa = require("kanagawa")

    local strongHighlight = "#fa7af6"

    kanagawa.setup({
      undercurl = true, -- enable undercurls
      commentStyle = {
        italic = true,
      },
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none"
            }
          }
        }
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
      overrides = function(colors)
        local theme = colors.theme
        return {
          IncSearch = { fg = "black", bg = strongHighlight, underline = true, bold = true },
          Search = { fg = "black", bg = colors.palette.oniViolet },
          Substitute = { fg = "black", bg = colors.palette.strongHighlight },
          Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
          PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
          PmenuSbar = { bg = theme.ui.bg_m1 },
          PmenuThumb = { bg = theme.ui.bg_p2 },
        }
      end,
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
    vim.cmd("colorscheme kanagawa")
  end
}
