local is_disabled = vim.g.disable_persisted == 1

return {
  "olimorris/persisted.nvim",
  lazy = false,
  opts = {
    autoload = not is_disabled,
    autosave = not is_disabled,
    use_git_branch = not is_disabled,
  },
  config = function(_, opts)
    local persisted = require("persisted")
    persisted.branch = function()
      local branch = vim.fn.systemlist("git branch --show-current")[1]
      return vim.v.shell_error == 0 and branch or nil
    end
    persisted.setup(opts)
  end,
}
