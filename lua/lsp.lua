require("sqlc")
M = {}

local mason_status_ok, mason = pcall(require, "mason")
local mason_tool_installer_ok, mason_tool_installer = pcall(require, "mason-tool-installer")

if not (mason_status_ok and mason_tool_installer_ok) then
	vim.api.nvim_err_writeln("Mason, Mason Tool Installer, Completion, or LSP Format not installed!")
	return
end

mason.setup()

-- These tools are automatically installed by Mason.
-- We then iterate over the LSPs (only) and load their relevant
-- configuration files, which are stored in lua/lsp/servers,
-- passing along the global on_attach and capabilities functions
-- We could have configurations for the other tools but it's not
-- been necessary for me thus far
local servers = {
	"rust-analyzer",
	"lua-language-server",
	"clojure-lsp",
	"eslint-lsp",
	"bash-language-server",
	"gopls",
	"golangci-lint-langserver",
	"astro-language-server",
	"typescript-language-server",
	"tailwindcss-language-server",
	"vue-language-server",
	"python-lsp-server",
	"terraform-ls",
	"css-lsp",
	"yaml-language-server",
	"prisma-language-server",
	"protols",
	"postgrestools",
	"json-lsp",
	"shellcheck",
}

-- Mason will not auto-install these
local linters = {
	"pylint",
}

-- Mason will not auto-install these
local debuggers = {
	"js-debug-adapter",
	"delve",
}

-- Mason will not auto-install these
local formatters = {
	"prettierd",
	"stylua",
	"sql-formatter", -- This does not support @ symbols, use https://github.com/nene/prettier-plugin-sql-cst instead
	"shfmt",
}

local all = merge(servers, linters, debuggers, formatters)

mason_tool_installer.setup({
	ensure_installed = all,
	run_on_start = true,
	automatic_installation = true,
})

M.on_attach = function(client, bufnr)
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	vim.lsp.log.set_format_func(vim.inspect)

	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Debounce by 300ms by default
	-- client.config.flags.debounce_text_changes = 300

	-- This will set up formatting for the attached LSPs
	if client.name == "gopls" or client.name == "json-lsp" then
		client.server_capabilities.documentFormattingProvider = true
	end

	-- Turn off semantic tokens (too slow)
	-- if client.server_capabilities.semanticTokensProvider = nil

	-- Keymaps
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, merge(global_keymap_opts, { desc = "Go to definition" }))
	vim.keymap.set(
		"n",
		"gt",
		vim.lsp.buf.type_definition,
		merge(global_keymap_opts, { desc = "Go to type definition" })
	)
	vim.keymap.set("n", "gD", function()
		vim.cmd("tab split")
		vim.lsp.buf.definition()
	end, merge(global_keymap_opts, { desc = "Go to definition in new tab" }))
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, merge(global_keymap_opts, { desc = "Go to implementation" }))
	vim.keymap.set("n", "gr", vim.lsp.buf.references, merge(global_keymap_opts, { desc = "Go to references" }))
	vim.keymap.set("n", "ga", vim.lsp.buf.code_action, merge(global_keymap_opts, { desc = "Code action" }))
	vim.keymap.set("n", "gc", vim.lsp.codelens.run, merge(global_keymap_opts, { desc = "Code action" }))

	-- Automatically fill struct (gopls)
	vim.keymap.set("n", "gf", function()
		vim.lsp.buf.code_action({
			filter = function(action)
				return action.kind == "refactor.rewrite.fillStruct"
			end,
			apply = true,
		})
	end, merge(global_keymap_opts, { desc = "Fill struct" }))

	vim.keymap.set("n", "K", vim.lsp.buf.hover, merge(global_keymap_opts, { desc = "Show hover information" }))
	vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, merge(global_keymap_opts, { desc = "Rename" }))
	vim.keymap.set(
		"n",
		"<leader>lt",
		vim.lsp.buf.type_definition,
		merge(global_keymap_opts, { desc = "Type definition" })
	)
	vim.keymap.set(
		"n",
		"<leader>lc",
		vim.lsp.buf.incoming_calls,
		merge(global_keymap_opts, { desc = "Incoming calls" })
	)

	vim.keymap.set("n", "]W", function()
		vim.diagnostic.jump({
			count = 1,
			severity = vim.diagnostic.severity.ERROR,
			float = true,
		})
	end, merge(global_keymap_opts, { desc = "Next error" }))

	vim.keymap.set("n", "[W", function()
		vim.diagnostic.jump({
			count = 1,
			severity = vim.diagnostic.severity.ERROR,
			float = true,
		})
	end, merge(global_keymap_opts, { desc = "Previous error" }))

	vim.keymap.set("n", "]w", function()
		vim.diagnostic.jump({
			count = 1,
			severity = vim.diagnostic.severity.WARN,
			float = true,
		})
	end, merge(global_keymap_opts, { desc = "Next warning" }))

	vim.keymap.set("n", "[w", function()
		vim.diagnostic.jump({
			count = 1,
			severity = vim.diagnostic.severity.WARN,
			float = true,
		})
	end, merge(global_keymap_opts, { desc = "Previous warning" }))

	vim.keymap.set("n", "]i", function()
		vim.diagnostic.jump({
			count = 1,
			severity = vim.diagnostic.severity.HINT,
			float = true,
		})
	end, merge(global_keymap_opts, { desc = "Next hint" }))

	vim.keymap.set("n", "[i", function()
		vim.diagnostic.jump({
			count = 1,
			severity = vim.diagnostic.severity.HINT,
			float = true,
		})
	end, merge(global_keymap_opts, { desc = "Previous hint" }))

	vim.keymap.set("n", "<leader>d", function()
		vim.diagnostic.setqflist({})
	end, merge(global_keymap_opts, { desc = "Show diagnostics" }))

	-- This is ripped off from https://github.com/kabouzeid/dotfiles, it's for tailwind preview support
	if client.name == "tailwindcss-language-server" then
		require("colorizer").buf_attach(bufnr, { single_column = false, debounce = 500 })
	end
end

-- Registers and enables all language servers
vim.lsp.config("*", {
	on_attach = M.on_attach,
	root_markers = {
		".git",
	},
})

-- Enable every LSP contained in the root lsp directory
local configs = {}
for _, v in ipairs(vim.api.nvim_get_runtime_file("lsp/*", true)) do
	local name = vim.fn.fnamemodify(v, ":t:r")
	table.insert(configs, name)
end
vim.lsp.enable(configs)

return M
