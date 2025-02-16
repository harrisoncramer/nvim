return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		image = { enabled = false },
		bigfile = { enabled = true },
		notifier = { enabled = true },
	},
}
