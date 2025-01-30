vim.api.nvim_create_user_command('DB', function()
  vim.fn.system("setDbUrls")
  vim.cmd("DBUI")
end, { nargs = 0 })

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
    -- Your DBUI configuration
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.dbs = {
      {
        name = 'prod',
        url = function()
          return os.getenv("PROD_DB_URL")
        end
      },
      {
        name = 'staging',
        url = function()
          return os.getenv("STAGING_DB_URL")
        end
      },
      {
        name = 'dev',
        url = function()
          return os.getenv("DEV_DATABASE_URL")
        end
      },
      {
        name = 'prod_read_only',
        url = function()
          return os.getenv("PROD_READ_ONLY_DB_URL")
        end
      },
    }
  end,
}
