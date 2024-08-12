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
    gitlab.setup({
      attachment_dir = "/Users/harrisoncramer/Desktop/screenshots",
      debug = { go_request = true, go_response = true },
      reviewer_settings = {
        diffview = {
          imply_local = false, -- If true, will attempt to use --imply_local option when calling |:DiffviewOpen|
        },
      },
      popup = {
        temporary_registers = { '"', "+", "g" },
      },
      keymaps = {
        global = {
          start_review = "glr",
          start_review_nowait = true,
        },
        discussion_tree = {
          switch_view = "S",
          switch_view_nowait = true,
        },
      },
      create_mr = {
        target = "main",
        template_file = "default.md",
        squash = true,
        delete_branch = true,
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
