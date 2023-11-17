return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "quangnguyen30192/cmp-nvim-ultisnips",
    "SirVer/ultisnips"
  },
  config = function()
    vim.cmd("let g:UltiSnipsJumpForwardTrigger=\"<c-e>\"")
  end
}
