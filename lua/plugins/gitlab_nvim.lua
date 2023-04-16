return {
  "harrisoncramer/gitlab.nvim",
  dependencies = {
    "sindrets/diffview.nvim",
    "rcarriga/nvim-notify",
    "MunifTanjim/nui.nvim"
  },
  config = function()
    local gitlab = require("gitlab")
    gitlab.setup({ project_id = 3, dev = true })
  end,
}
