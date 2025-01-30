return {
  'saghen/blink.cmp',
  version = '*',
  opts = {
    signature = {},
    keymap = {
      ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-e>'] = { 'select_and_accept' },
      ['<C-p>'] = { 'select_prev', 'fallback' },
      ['<C-n>'] = { 'select_next', 'fallback' },
      ['<C-d>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-u>'] = { 'scroll_documentation_down', 'fallback' },
    },
    completion = {
      documentation = {
        auto_show = false,
      }
    },
    appearance = {
      nerd_font_variant = 'mono'
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer', 'dadbod' },
      providers = {
        dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
      },
    },
  },
  opts_extend = { "sources.default" }
}
