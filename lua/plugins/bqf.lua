local function setup()
  local function toggleQf()
    local ft = vim.bo.filetype
    if ft == "qf" then
      vim.cmd.cclose()
    else
      vim.cmd.copen()
    end
  end

  vim.keymap.set("n", "<leader>q", toggleQf, {})
  vim.keymap.set("n", "]q", ":cnext<CR>", {})
  vim.keymap.set("n", "[q", ":cprev<CR>", {})

  require("bqf").setup({
    preview = {
      border_chars = { "│", "│", "─", "─", "╭", "╮", "╰", "╯", "│" },
    },
    filter = {
      fzf = {
        action_for = {
          ["enter"] = "signtoggle",
        },
      },
    },
  })
end

return { "kevinhwang91/nvim-bqf", requires = "junegunn/fzf.vim", config = setup }
