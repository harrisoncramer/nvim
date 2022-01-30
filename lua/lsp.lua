local cmp_status_ok, cmp = pcall(require, "cmp")
local lspconfig_status_ok, util = pcall(require, "lspconfig/util")
local lsp_installer_status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
local lspkind_status_ok, lspkind = pcall(require, "lspkind")
local renamer_status_ok, renamer = pcall(require, "renamer")
local cmp_nvim_lsp_status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

-- Setup renamer
if renamer_status_ok then
	renamer.setup({})
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

if not (cmp_nvim_lsp_status_ok and lspconfig_status_ok and lsp_installer_status_ok and lspkind_status_ok) then
	print("LSP dependencies not yet installed!")
	return
end

local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Map keys after LSP attaches (utility function)
local on_attach = function(client, bufnr)
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Turn off formatting by default
	client.resolved_capabilities.document_formatting = false

	vim.keymap.set("n", "gd", vim.lsp.buf.definition)
	vim.keymap.set("n", "K", vim.lsp.buf.hover)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help)
	vim.keymap.set("n", "<leader>R", require("renamer").rename)
	vim.keymap.set("n", "<leader>[", vim.diagnostic.goto_prev)
	vim.keymap.set("n", "<leader>]", vim.diagnostic.goto_next)
end

-- Global diagnostic settings
vim.diagnostic.config({
	virtual_text = false,
	severity_sort = true,
	update_in_insert = false,
	float = {
		header = "",
		source = "always",
		border = "rounded",
		focusable = true,
	},
})

-- Change Error Signs in Gutter
local signs = { Error = "✘", Warn = " ", Hint = "", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Also installed: tailwindcss, tsserver, emmet-ls
-- Loop over installed servers and set them up. Register a handler that will be called for all installed servers.
lsp_installer.on_server_ready(function(server)
	vim.inspect(server.name)
	local opts = {
		capabilities = capabilities,
		on_attach = on_attach,
		auto_start = true,
		flags = { debounce_text_changes = 500 },
	}
	if server.name == "volar" then
		opts.init_options = {
			typescript = {
				serverPath = vim.api.nvim_eval("$TS_SERVER"), -- This must be passed in via the startup in .zshrc....
			},
			languageFeatures = {
				references = true,
				definition = true,
				typeDefinition = true,
				callHierarchy = true,
				hover = false,
				rename = true,
				signatureHelp = true,
				codeAction = true,
				completion = {
					defaultTagNameCase = "both",
					defaultAttrNameCase = "kebabCase",
				},
				schemaRequestService = true,
				documentHighlight = true,
				codeLens = true,
				semanticTokens = true,
				diagnostics = true,
			},
			documentFeatures = {
				selectionRange = true,
				foldingRange = true,
				linkedEditingRange = true,
				documentSymbol = true,
				documentColor = true,
			},
		}
		opts.settings = {
			volar = {
				codeLens = {
					references = true,
					pugTools = true,
					scriptSetupTools = true,
				},
			},
		}
		opts.root_dir = util.root_pattern("package.json", "vue.config.js")
	end
	if server.name == "sqlls" then
		util.root_pattern(".git")
	end
	if server.name == "vuels" then
		opts.root_dir = util.root_pattern("package.json", "vue.config.js")
		opts.settings = {
			vetur = {
				ignoreProjectWarning = true,
				completion = { autoImport = true, useScaffoldSnippets = true },
				validation = {
					template = true,
					script = true,
					style = true,
					templateProps = true,
					interpolation = true,
				},
			},
		}
	end
	if server.name == "sumneko_lua" then
		opts.settings = {
			Lua = {
				runtime = {
					-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
					version = "LuaJIT",
					-- Setup your lua path
					path = vim.split(package.path, ";"),
				},
				diagnostics = {
					-- Get the language server to recognize the `vim` global
					globals = {
						"vim",
						"nnoremap",
						"vnoremap",
						"inoremap",
						"tnoremap",
						"use",
					},
				},
				workspace = {
					-- Make the server aware of Neovim runtime files
					library = {
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
					},
				},
			},
		}
	end
	if server.name == "jsonls" then
		opts.filetypes = { "json", "jsonc" }
	end
	if server.name == "bashls" then
		opts.filetypes = { "bash", "zsh" }
	end
	-- This setup() function is exactly the same as lspconfig's setup function.
	-- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
	server:setup(opts)
end)
