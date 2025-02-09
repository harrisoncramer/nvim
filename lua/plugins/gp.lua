local u = require("functions.utils")

local ai_prompt = {
	"",
	"For the duration of this conversation, keep your answers terse.",
	"If you provide code snippets, also make them short.",
	"If I prefix a message with LONG you may provide a lengthier response with examples or more english text.",
	"",
}

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
		-- <C-a>f Find old conversation
		vim.keymap.set({ "n", "i" }, "<C-a>c", function()
			vim.cmd("GpChatNew popup")
			u.press_enter()
			vim.api.nvim_put(ai_prompt, "c", true, true)
		end, keymapOptions("New Chat"))

		vim.keymap.set({ "n", "i" }, "<C-a><C-a>", function()
			vim.cmd("GpChatToggle popup")
			u.press_enter()
		end, keymapOptions("Toggle Chat"))

		vim.keymap.set({ "n", "i" }, "<C-a>f", function()
			vim.cmd("GpChatFinder")
			u.press_enter()
		end, keymapOptions("Chat Finder")) -- Find old chat

		-- Chat mode
		vim.keymap.set("v", "<C-a>c", function()
			vim.cmd("normal! gv")
			vim.cmd("'<,'>GpChatNew popup")
			u.press_enter()
			vim.api.nvim_put(ai_prompt, "c", true, true)
		end, keymapOptions("Visual Chat New"))

		-- Injection mode <C-a>r(ewrite) <C-a>a(ppend)
		vim.keymap.set("v", "<C-a>a", ":<C-u>'<,'>GpAppend<cr>", keymapOptions("Visual Append (after)"))
		vim.keymap.set("v", "<C-a>r", ":<C-u>'<,'>GpRewrite<cr>", { desc = "Visual Write" })
	end,
}
