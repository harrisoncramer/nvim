return {
	"harrisoncramer/before.nvim",
	config = function()
		local before = require("before")

		before.setup()

		-- Jump to previous entry in the edit history
		vim.keymap.set("n", "<C-p>", function()
			local jumped = before.jump_to_last_edit()
			if jumped ~= true then
				local keys = vim.api.nvim_replace_termcodes("<C-o>", true, false, true)
				vim.api.nvim_feedkeys(keys, "n", false)
			end
		end, {})

		-- Jump to next entry in the edit history
		vim.keymap.set("n", "<C-n>", function()
			local jumped = before.jump_to_next_edit()
			if not jumped then
				local keys = vim.api.nvim_replace_termcodes("<C-i>", true, false, true)
				vim.api.nvim_feedkeys(keys, "n", false)
			end
		end, {})
	end,
}
