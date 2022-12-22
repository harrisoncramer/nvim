return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "quangnguyen30192/cmp-nvim-ultisnips",
    "SirVer/ultisnips"
  },
  config = function()
    require("cmp_nvim_ultisnips").setup({})
  end
}
