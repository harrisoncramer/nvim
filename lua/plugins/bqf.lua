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
      description = "Make BQF opaque",
      winblend = 0,
    },
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
