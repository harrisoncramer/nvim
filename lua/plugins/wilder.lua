return {
  'gelguy/wilder.nvim',
  config = function()
    local wilder = require('wilder')

    wilder.setup({
      modes = { ':', '/', '?' },
      next_key = '<C-n>',
      previous_key = '<C-p>',
    })

    wilder.set_option('renderer', wilder.renderer_mux({
      [":"] = wilder.popupmenu_renderer({
        highlighter = wilder.basic_highlighter(),
        left = { " ", wilder.popupmenu_devicons() },
        right = { " ", wilder.popupmenu_scrollbar() },
      }),
      ["/"] = wilder.popupmenu_renderer({
        highlighter = wilder.basic_highlighter(),
        right = { " ", wilder.popupmenu_scrollbar() },
      }),
    }))

    wilder.set_option('pipeline', {
      wilder.branch(
        wilder.cmdline_pipeline({
          -- sets the language to use, 'vim' and 'python' are supported
          language = 'python',
          -- 0 turns off fuzzy matching
          -- 1 turns on fuzzy matching
          -- 2 partial fuzzy matching (match does not have to begin with the same first letter)
          fuzzy = 1,
        }),
        wilder.python_search_pipeline({
          -- can be set to wilder#python_fuzzy_delimiter_pattern() for stricter fuzzy matching
          pattern = wilder.python_fuzzy_pattern(),
          -- omit to get results in the order they appear in the buffer
          sorter = wilder.python_difflib_sorter(),
          -- can be set to 're2' for performance, requires pyre2 to be installed
          -- see :h wilder#python_search() for more details
          engine = 're',
        })
      ),
    })

  end,
}
