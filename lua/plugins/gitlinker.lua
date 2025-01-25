return {
  'ruifm/gitlinker.nvim',
  dependencies = 'nvim-lua/plenary.nvim',
  config = function()
    require "gitlinker".setup({
      opts = {
        print_url = false,
        action_callback = function(...)
          require("gitlinker.actions").copy_to_clipboard(...)
          vim.notify("Copied location to clipboard")
        end,
      },
    })
  end
}
