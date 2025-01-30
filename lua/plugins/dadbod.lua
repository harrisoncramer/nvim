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
    vim.g.db_adapter_ssh_port_range = vim.fn.range(5431, 5431)
    -- Your DBUI configuration
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.dbs = {
      {
        name = 'prod',
        url = function()
          return vim.fn.trim(vim.fn.system('getDbUrl prod'))
        end
      },
      {
        name = 'staging',
        url = function()
          return vim.fn.trim(vim.fn.system('getDbUrl staging'))
        end
      },
      {
        name = 'dev',
        url = function()
          return vim.fn.system('getDbUrl dev')
        end
      },
      {
        name = 'prod_read_only',
        url = function()
          return vim.fn.trim(vim.fn.system('getDbUrl prod_read_only'))
        end
      },
    }
  end,
}
