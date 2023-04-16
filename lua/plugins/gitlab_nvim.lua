return {
  "harrisoncramer/gitlab.nvim",
  dependencies = {
    "rcarriga/nvim-notify",
    "MunifTanjim/nui.nvim"
  },
  config = function()
    require('gitlab_nvim').setup({ project_id = 3 })
  end,
}
