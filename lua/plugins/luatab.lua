local colors = require("colorscheme")
return {
  "alvarosevilla95/luatab.nvim",
  requires = "kyazdani42/nvim-web-devicons",
  config = function()
    vim.keymap.set("n", "<leader>tn", ":tabnext<CR>")
    vim.keymap.set("n", "<leader>tp", ":tabprev<CR>")
    vim.keymap.set("n", "<leader>tc", ":bd<CR>")
    require("luatab").setup({
      devicon = function() return '' end,
      separator = function(v) return '' end
    })
    vim.api.nvim_set_hl(0, 'TabLineSel', { bg = colors.crystalBlue, fg = 'black' })
    vim.api.nvim_set_hl(0, 'TabLine', { bg = colors.backgroundDark })
    vim.api.nvim_set_hl(0, 'TabLineFill', { bg = colors.backgroundDark })
  end
}
