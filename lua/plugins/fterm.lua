local colorscheme = require("colorscheme")
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
    vim.keymap.set("n", "<C-z>", function()
      fTerm.toggle()
      local ns = vim.api.nvim_create_namespace(vim.bo.filetype)
      vim.api.nvim_win_set_hl_ns(0, ns)
      vim.api.nvim_set_hl(ns, "Normal", { bg = colorscheme.backgroundDark })
    end, {})
    vim.keymap.set("t", "<C-z>", function()
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes("<C-\\><C-n>:lua require('FTerm').toggle()<CR>", false, true, true), "n", false)
    end)
    require 'FTerm'.setup({
      border     = 'none',
      ft         = 'terminal',
      dimensions = {
        height = .5,
        width = 1,
        x = 0, -- X axis of the terminal window
        y = 1, -- Y axis of the terminal window
      },
    })
    vim.api.nvim_create_autocmd('FileType', {
      pattern = "terminal",
      callback = function()
        local ns = vim.api.nvim_create_namespace(vim.bo.filetype)
        vim.api.nvim_win_set_hl_ns(0, ns)
        vim.api.nvim_set_hl(ns, "Normal", { bg = '#171717' })
      end,
    })
  end
}
