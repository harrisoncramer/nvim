vim.api.nvim_create_autocmd(
  "User",
  {
    pattern = "UnceptionEditRequestReceived",
    callback = function()
      -- Toggle the terminal off.
      require('FTerm').toggle()
    end
  }
)

return {
  "numToStr/FTerm.nvim",
  config = function()
    local fTerm = require("FTerm")
    vim.keymap.set("n", "<C-z>", fTerm.toggle, {})
    vim.keymap.set("t", "<C-z>", '<C-\\><C-n>:lua require("FTerm").toggle()<CR>')
  end
}
