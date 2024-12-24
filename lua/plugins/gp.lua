local function keymapOptions(desc)
  return {
    noremap = true,
    silent = true,
    nowait = true,
    desc = "GPT prompt " .. desc,
  }
end

return {
  "robitx/gp.nvim",
  config = function()
    require("gp").setup()

    -- Update global context for repo
    vim.keymap.set("v", "<C-a>x", ":<C-u>'<,'>GpContext<cr>", keymapOptions("Visual Toggle Context"))

    -- Chat commands
    vim.keymap.set({ "n", "i" }, "<C-a>f", "<cmd>GpChatFinder<cr>", keymapOptions("Chat Finder")) -- Find old chat

    -- Update context (per repository)
    vim.keymap.set({ "n", "i" }, "<C-a>x", "<cmd>GpContext<cr>", keymapOptions("Toggle Context"))

    -- Normal mode
    vim.keymap.set({ "n", "i" }, "<C-a>c", "<cmd>GpChatNew vsplit<cr>", keymapOptions("New Chat"))
    vim.keymap.set({ "n", "i" }, "<C-a>t", "<cmd>GpChatToggle<cr>", keymapOptions("Toggle Chat"))

    -- Chat mode
    vim.keymap.set("v", "<C-a>c", ":<C-u>'<,'>GpChatNew<cr>", keymapOptions("Visual Chat New"))
    vim.keymap.set("v", "<C-a>t", ":<C-u>'<,'>GpChatToggle<cr>", keymapOptions("Visual Toggle Chat"))
    vim.keymap.set("v", "<C-a>p", ":<C-u>'<,'>GpChatPaste<cr>", keymapOptions("Visual Chat Paste"))

    -- Injection mode <C-a>r(ewrite) <C-a>a(ppend)
    vim.keymap.set("v", "<C-a>a", ":<C-u>'<,'>GpAppend<cr>", keymapOptions("Visual Append (after)"))
    vim.keymap.set("v", "<C-a>r", ":<C-u>'<,'>GpRewrite<cr>", { desc = "Visual Write" })
  end,
}
