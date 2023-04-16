return {
  "harrisoncramer/jump-tag",
  config = function()
    local jump = require("jump-tag")
    vim.keymap.set("n", "<leader>jj", jump.jumpParent, {})
    vim.keymap.set("n", "<leader>jn", jump.jumpNextSibling, {})
    vim.keymap.set("n", "<leader>jp", jump.jumpPrevSibling, {})
    vim.keymap.set("n", "<leader>jc", jump.jumpChild, {})
  end
}
