return {
  "alvarosevilla95/luatab.nvim",
  requires = "kyazdani42/nvim-web-devicons",
  config = function()
    vim.keymap.set("n", "<leader>tn", ":tabnext<CR>")
    vim.keymap.set("n", "<leader>tp", ":tabprev<CR>")
    vim.keymap.set("n", "<leader>tc", ":bd<CR>")
    require("luatab").setup({ separator = function() return "" end })
  end
}
