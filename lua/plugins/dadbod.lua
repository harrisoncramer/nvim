return {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'tpope/vim-dadbod',                     lazy = true },
    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },
  init = function()
    local colors = require("colorscheme")

    vim.cmd(string.format('hi NotificationInfo guifg=%s guibg=%s', colors.sumiInk1, colors.autumnGreen))
    vim.cmd(string.format('hi NotificationWarning guifg=%s guibg=%s', colors.sumiInk1, colors.carpYellow))
    vim.cmd(string.format('hi NotificationError guifg=%s guibg=%s', colors.sumiInk1, colors.autumnRed))

    -- Your DBUI configuration
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.dbs = {
      {
        name = 'dev',
        url = function()
          return vim.fn.system("getDbUrl dev")
        end
      },
      {
        name = 'staging',
        url = function()
          return vim.fn.system("getDbUrl staging")
        end
      },
      {
        name = 'prod_read_only',
        url = function()
          return vim.fn.system("getDbUrl prod_read_only")
        end
      },
      {
        name = 'prod',
        url = function()
          return vim.fn.system("getDbUrl prod")
        end
      },
    }
  end,
}
