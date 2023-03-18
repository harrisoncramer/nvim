return {
  'gelguy/wilder.nvim',
  dependencies = 'romgrk/fzy-lua-native',
  build = ':UpdateRemotePlugins',
  config = function()
    local wilder = require('wilder')
    wilder.setup({ modes = { ':', '/', '?' } })
    local colors = require("colorscheme")

    -- Disable Python remote plugin
    wilder.set_option('use_python_remote_plugin', 0)

    wilder.set_option('pipeline', {
      wilder.branch(
        wilder.cmdline_pipeline({
          fuzzy = 1,
          fuzzy_filter = wilder.lua_fzy_filter(),
        }),
        wilder.vim_search_pipeline()
      )
    })

    wilder.set_option('renderer', wilder.renderer_mux({
      [':'] = wilder.popupmenu_renderer(
        wilder.popupmenu_border_theme(
          {
            highlighter = wilder.lua_fzy_highlighter(),
            highlights = {
              accent = wilder.make_hl('WilderAccent', 'Pmenu', { { a = 1 }, { a = 1 }, { foreground = colors.peachRed } }),
            },
            left = {
              ' ',
              wilder.popupmenu_devicons()
            },
            right = {
              ' ',
              wilder.popupmenu_scrollbar()
            },
          }
        )
      ),
      ['/'] = wilder.popupmenu_renderer(
        wilder.popupmenu_border_theme({
          highlighter = wilder.lua_fzy_highlighter(),
          highlights = {
            accent = wilder.make_hl('WilderAccent', 'Pmenu', { { a = 1 }, { a = 1 }, { foreground = colors.peachRed } }),
          },
          right = {
            ' ',
            wilder.popupmenu_scrollbar()
          },
        })
      ),
    }))

    wilder.setup({
      modes = { ':', '/', '?' },
      next_key = '<C-n>',
      previous_key = '<C-p>',
    })
  end,
}
