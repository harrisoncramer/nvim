return {
	"nvim-pack/nvim-spectre",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = {
		replace_engine = {
			["sed"] = {
				cmd = "sed",
				args = vim.fn.has("mac") == 1 and {
					"-i",
					"",
					"-E",
				} or {
					"-i",
					"-E",
				},
			},
		},
	},
}
