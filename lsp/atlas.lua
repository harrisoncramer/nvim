--- @class vim.lsp.Config
--- Atlas language server for schema-as-code HCL. It attaches to the Atlas
--- filetypes set in lua/settings.lua, not to plain `hcl`, so terraform-ls does
--- not claim the Atlas files. The server recognizes schema files by their
--- dialect suffix on disk, so those files must be named *.pg.hcl for Postgres.
return {
	cmd = {
		"atlas",
		"tool",
		"lsp",
		"--stdio",
	},
	filetypes = {
		"atlas-config",
		"atlas-schema-postgresql",
	},
	root_markers = {
		"atlas.hcl",
	},
}
