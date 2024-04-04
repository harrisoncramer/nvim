return {
  "harrisoncramer/gitlab.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
  },
  build = function()
    require("gitlab.server").build()
  end,
  -- dir = "~/.config/nvim/dev-plugins/gitlab",
  config = function()
    local gitlab = require("gitlab")
    vim.keymap.set("n", "gls", gitlab.summary)
    vim.keymap.set("n", "glr", gitlab.review)
    vim.keymap.set("n", "glo", gitlab.open_in_browser)
    vim.keymap.set("n", "glA", gitlab.approve)
    vim.keymap.set("n", "glR", gitlab.revoke)
    vim.keymap.set("n", "glc", gitlab.create_comment)
    vim.keymap.set("v", "glc", gitlab.create_multiline_comment)
    vim.keymap.set("n", "gln", gitlab.create_note)
    vim.keymap.set("v", "gln", gitlab.create_comment_suggestion)
    vim.keymap.set("n", "gld", gitlab.toggle_discussions)
    vim.keymap.set("n", "glaa", gitlab.add_assignee)
    vim.keymap.set("n", "glad", gitlab.delete_assignee)
    vim.keymap.set("n", "glra", gitlab.add_reviewer)
    vim.keymap.set("n", "glrd", gitlab.delete_reviewer)
    vim.keymap.set("n", "glp", gitlab.pipeline)
    vim.keymap.set("n", "glm", gitlab.move_to_discussion_tree_from_diagnostic)
    vim.keymap.set("n", "glM", gitlab.merge)
    vim.keymap.set("n", "glO", gitlab.create_mr)
    vim.keymap.set("n", "glal", gitlab.add_label)
    vim.keymap.set("n", "gldl", gitlab.delete_label)

    gitlab.setup({
      attachment_dir = "/Users/harrisoncramer/Desktop/screenshots",
      debug = { go_request = true, go_response = true },
      reviewer_settings = {
        diffview = {
          imply_local = true, -- If true, will attempt to use --imply_local option when calling |:DiffviewOpen|
        },
      },
      popup = {
        backup_register = "+",
      },
      create_mr = {
        target = "main",
        template_file = "default.md"
      },
      discussion_signs = {
        severity = vim.diagnostic.severity.WARN,
      },
      discussion_tree = {
        position = "bottom",
        blacklist = {
          "project_7092381_bot_a74db8ad297ab0341e5720af7849e36f",
          -- "project_45056705_bot_b8d05ad0fd92c0255adb37ca4823d010"
        },
        tree_type = "simple",
      },
    })
  end,
}
