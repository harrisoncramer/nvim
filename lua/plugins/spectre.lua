return {
	"nvim-pack/nvim-spectre",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = {
		replace_engine = {
			["sed"] = {
				cmd = "sed",
				args = {
					"-i",
					"",
					"-E",
				},
			},
		},
	},
}
