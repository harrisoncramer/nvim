return {
  "harrisoncramer/gitlab.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
  },
  build = function()
    require("gitlab.server").build()
  end,
  dir = "~/.config/nvim/dev-plugins/gitlab",
  config = function()
    local gitlab = require("gitlab")
    vim.keymap.set("n", "<leader>gls", gitlab.summary)
    vim.keymap.set("n", "<leader>glr", gitlab.review)
    vim.keymap.set("n", "<leader>glo", gitlab.open_in_browser)
    vim.keymap.set("n", "<leader>glA", gitlab.approve)
    vim.keymap.set("n", "<leader>glR", gitlab.revoke)
    vim.keymap.set("n", "<leader>glc", gitlab.create_comment)
    vim.keymap.set("v", "<leader>glc", gitlab.create_multiline_comment)
    vim.keymap.set("n", "<leader>gln", gitlab.create_note)
    vim.keymap.set("v", "<leader>gln", gitlab.create_comment_suggestion)
    vim.keymap.set("n", "<leader>gld", gitlab.toggle_discussions)
    vim.keymap.set("n", "<leader>glaa", gitlab.add_assignee)
    vim.keymap.set("n", "<leader>glad", gitlab.delete_assignee)
    vim.keymap.set("n", "<leader>glra", gitlab.add_reviewer)
    vim.keymap.set("n", "<leader>glrd", gitlab.delete_reviewer)
    vim.keymap.set("n", "<leader>glp", gitlab.pipeline)
    vim.keymap.set("n", "<leader>glm", gitlab.move_to_discussion_tree_from_diagnostic)

    gitlab.setup({
      attachment_dir = "/Users/harrisoncramer/Desktop/screenshots",
      discussion_sign = {
        -- See :h sign_define for details about sign configuration.
        enabled = true,
        text = "↳",
        linehl = 'DiagnosticSignWarn',
        texthl = 'DiagnosticSignWarn',
        culhl = nil,
        numhl = nil,
        priority = 20,
        helper_signs = {
          enabled = false,
        },
      },
      discussion_diagnostic = {
        enabled = true,
        severity = vim.diagnostic.severity.WARN,
        code = 'gitlab.nvim',
        display_opts = {
          virtual_text = false,
          severity_sort = true,
        },
      },
      discussion_tree = {
        position = "bottom",
        blacklist = { "project_7092381_bot_a74db8ad297ab0341e5720af7849e36f" },
        resolved = '✓',
        unresolved = '',
      },
      colors = {
        discussion_tree = {
          chevron = 'DiagnosticSignWarn'
        }
      }
    })
  end,
}
