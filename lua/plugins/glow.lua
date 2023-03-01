vim.keymap.set("n", "<localleader>gl", function()
  vim.cmd.Glow()
end, {})

return {
  "ellisonleao/glow.nvim",
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "glowpreview",
      callback = function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>T", false, true, true), "n", false)
      end,
      desc = "Opens a new tab for the glow preview",
    })

    local glow = require("glow")
    glow.setup({
      width_ratio = 1,
      height_ratio = 1,
    })
  end,
  cmd = "Glow"
}
