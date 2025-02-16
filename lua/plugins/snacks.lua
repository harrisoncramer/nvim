return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	config = function()
		vim.keymap.set({ "n", "t" }, "<C-z>", function()
			local current_dir = vim.fn.expand("%:p:h")
			if current_dir == "" or vim.fn.isdirectory(current_dir) == 0 then
				current_dir = vim.fn.getcwd()
			end

			local in_terminal = vim.bo.buftype == "terminal"
			if in_terminal then
				vim.cmd("hide")
			else
				Snacks.terminal.toggle("zsh", {
					-- cwd = current_dir,
					env = {
						TERM = "xterm-256color",
					},
					win = {
						style = "terminal",
						relative = "editor",
						width = 0.83,
						height = 0.83,
					},
				})
			end
		end, { desc = "Toggle ZSH Terminal" })

		---@type snacks.Config
		return {
			image = { enabled = false },
			bigfile = { enabled = true },
			notifier = { enabled = true },
			terminal = {
				bo = {
					filetype = "snacks_terminal",
				},
				win = { style = "terminal" },
				enabled = true,
			},
		}
	end,
}
