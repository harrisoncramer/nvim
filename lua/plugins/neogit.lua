return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim", -- required
    "sindrets/diffview.nvim",
    "ibhagwan/fzf-lua",      -- optional
  },
  config = function()
    local map_opts = { noremap = true, silent = true, nowait = true, buffer = false }
    vim.keymap.set("n", "<leader>gs", ":Neogit<CR>", map_opts)
    vim.cmd([[
      highlight NeogitSectionHeader guifg=#957FB8
      highlight NeogitChangeDeleted guifg=#FF5D62
      highlight NeogitChangeModified guifg=#C0A36E
    ]])
    require("neogit").setup({})
  end
}
