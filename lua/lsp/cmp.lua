local cmp_status_ok, cmp = pcall(require, "cmp")
local lspkind_status_ok, lspkind = pcall(require, "lspkind")

if not (cmp_status_ok and lspkind_status_ok) then
	print("CMP dependencies not yet installed!")
	return
end

-- Setup completion engine
if cmp_status_ok then
	cmp.setup({
		snippet = {
			expand = function(args)
				vim.fn["UltiSnips#Anon"](args.body)
			end,
		},
		formatting = {
			format = lspkind.cmp_format({
				with_text = false, -- do not show text alongside icons
				maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
			}),
		},
		mapping = {
			["<CR>"] = cmp.mapping.confirm({ select = true }),
			["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		},
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "nvim_lua" },
			{ name = "ultisnips" },
			{ name = "buffer" },
		}),
	})
end
