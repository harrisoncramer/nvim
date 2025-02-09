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

		-- Normal mode
		-- <C-a>c Toggle new conversation
		-- <C-a><C-a> Toggle conversation
		vim.keymap.set({ "n", "i" }, "<C-a>c", "<cmd>GpChatNew popup<cr>", keymapOptions("New Chat"))
		vim.keymap.set({ "n", "i" }, "<C-a><C-a>", "<cmd>GpChatToggle popup<cr>", keymapOptions("Toggle Chat"))

		-- Chat mode
		vim.keymap.set("v", "<C-a>c", ":<C-u>'<,'>GpChatNew popup<cr>", keymapOptions("Visual Chat New"))

		-- Injection mode <C-a>r(ewrite) <C-a>a(ppend)
		vim.keymap.set("v", "<C-a>a", ":<C-u>'<,'>GpAppend<cr>", keymapOptions("Visual Append (after)"))
		vim.keymap.set("v", "<C-a>r", ":<C-u>'<,'>GpRewrite<cr>", { desc = "Visual Write" })
	end,
}
