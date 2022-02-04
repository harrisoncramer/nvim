local OS = require("functions").getOS

return {
	setup = function()
		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting

		local sources = {
			formatting.eslint_d,
			formatting.stylua,
		}

		if OS() == "Darwin" then
			table.insert(sources, formatting.prettierd)
			table.insert(sources, formatting.joker.with({ filetypes = { "clojure" } }))
		end

		null_ls.setup({
			debug = false,
			sources = sources,
		})
	end,
}
