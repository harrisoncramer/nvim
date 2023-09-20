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
    vim.keymap.set("n", "<leader>gln", gitlab.create_note)
    vim.keymap.set("n", "<leader>gld", gitlab.toggle_discussions)
    vim.keymap.set("n", "<leader>glaa", gitlab.add_assignee)
    vim.keymap.set("n", "<leader>glad", gitlab.delete_assignee)
    vim.keymap.set("n", "<leader>glra", gitlab.add_reviewer)
    vim.keymap.set("n", "<leader>glrd", gitlab.delete_reviewer)
    vim.keymap.set("n", "<leader>glp", gitlab.pipeline)
    gitlab.setup({
      attachment_dir = "/Users/harrisoncramer/Desktop/screenshots",
      reviewer = "diffview",
      discussion_tree = {
        position = "bottom",
        blacklist = { "project_7092381_bot_a74db8ad297ab0341e5720af7849e36f" },
        resolved = '✓',
        unresolved = '',
      },
    })
  end,
}
