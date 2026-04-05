local parsers = {
	"javascript",
	"typescript",
	"go",
	"vue",
	"clojure",
	"lua",
	"css",
	"bash",
	"json",
	"sql",
	"dockerfile",
	"html",
	"python",
	"scss",
	"rust",
	"markdown",
	"hcl",
	"astro",
	"tsx",
	"terraform",
	"proto",
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			require("nvim-treesitter").setup({})
			require("nvim-treesitter").install(parsers)

			vim.treesitter.language.register("markdown", "mdx")

			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local ft = vim.bo[args.buf].filetype
					if ft == "help" then
						return
					end
					local buf_name = vim.api.nvim_buf_get_name(args.buf)
					if ft == "clojure" and buf_name:find("conjure%-") then
						return
					end
					pcall(vim.treesitter.start, args.buf)
				end,
			})

			-- Treesitter-based indentation
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})

			-- Incremental selection
			vim.keymap.set("n", "v", function()
				require("nvim-treesitter.incremental_selection").init()
			end, { desc = "Start incremental selection" })
			vim.keymap.set("x", "v", function()
				require("nvim-treesitter.incremental_selection").increment()
			end, { desc = "Increment selection" })
			vim.keymap.set("x", "V", function()
				require("nvim-treesitter.incremental_selection").decrement()
			end, { desc = "Decrement selection" })
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					lookahead = true,
					selection_modes = {
						["@function.outer"] = "V",
					},
					include_surrounding_whitespace = true,
				},
			})

			vim.keymap.set({ "x", "o" }, "af", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
			end, { desc = "All of a function definition" })

			vim.keymap.set({ "x", "o" }, "if", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
			end, { desc = "Inner part of a function definition" })

			vim.keymap.set({ "x", "o" }, "ac", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@comment.outer", "textobjects")
			end, { desc = "All of a comment" })
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-ts-autotag").setup({})
		end,
	},
}
