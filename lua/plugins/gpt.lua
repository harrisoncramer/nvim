return {
  "jackMort/ChatGPT.nvim",
  event = "VeryLazy",
  opts = {
    answer_sign = ">", -- 🤖
    chat_input = {
      prompt = "> ",
      border = {
        highlight = "FloatBorder",
        style = "rounded",
        text = {
          top_align = "center",
          top = " Prompt ",
        },
      },
    },
    keymaps = {
      close = { "<C-c>", "<Esc>" },
      submit = "<Enter>",
      yank_last = "<C-y>",
      yank_last_code = "<C-k>",
      scroll_up = "<C-u>",
      scroll_down = "<C-d>",
      toggle_settings = "<C-o>",
      new_session = "<C-n>",
      cycle_windows = "<Tab>",
      -- in the Sessions pane
      select_session = "<Space>",
      rename_session = "r",
      delete_session = "d",
    }
  },
  cond = function()
    return vim.env.COMPUTER == "personal"
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim"
  }
}
