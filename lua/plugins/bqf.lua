local function setup()
  local function toggleQf()
    local ft = vim.bo.filetype
    if ft == "qf" then
      vim.cmd.cclose()
    else
      vim.cmd.copen()
    end
  end

  vim.keymap.set("n", "<leader>q", toggleQf, {})
  vim.keymap.set("n", "]q", ":cnext<CR>", {})
  vim.keymap.set("n", "[q", ":cprev<CR>", {})

  require("bqf").setup({
    border = 'rounded',
    preview = {
      winblend = 0,
    },
    filter = {
      fzf = {
        action_for = {
          ['ctrl-q'] = {
            description = [[Press ctrl-q to toggle sign for the selected items]],
            default = 'signtoggle'
          },
          ['ctrl-t'] = {
            description = [[Press ctrl-t to open up the item in a new tab]],
            default = 'tabedit'
          },
          ['ctrl-v'] = {
            description = [[Press ctrl-v to open up the item in a new vertical split]],
            default = 'vsplit'
          },
          ['ctrl-x'] = {
            description = [[Press ctrl-x to open up the item in a new horizontal split]],
            default = 'split'
          },
          ['ctrl-c'] = {
            description = [[Press ctrl-c to close quickfix window and abort fzf]],
            default = 'closeall'
          }
        },
        -- This is not working
        -- extra_opts = {
        --   description = 'Extra options for fzf',
        --   default = { '--bind', 'ctrl-s:select-all' }
        -- }
      }
    }
  })
end


return {
  "kevinhwang91/nvim-bqf",
  dependencies = {
    {
      'junegunn/fzf',
      run = function()
        vim.fn['fzf#install']()
      end
    },
  },
  config = setup,
}
