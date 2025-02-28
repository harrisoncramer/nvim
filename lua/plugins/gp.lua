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

		-- Do not care about chat buffers when quitting Neovim
		vim.api.nvim_create_autocmd("BufUnload", {
			pattern = "~/.local/share/nvim/gp/chats/*.md",
			callback = function()
				vim.bo.modified = false
			end,
		})

		-- Injection mode <C-a>r(ewrite) <C-a>a(ppend)
		vim.keymap.set("v", "<C-a>a", ":<C-u>'<,'>GpAppend<cr>", keymapOptions("Visual Append (after)"))
		vim.keymap.set("v", "<C-a>r", ":<C-u>'<,'>GpRewrite<cr>", { desc = "Visual Write" })
	end,
}
