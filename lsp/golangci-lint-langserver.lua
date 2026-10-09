local cwd = vim.fn.getcwd()

-- Resolve the repo's custom golangci-lint binary, handling worktrees where the
-- binary lives under .worktrees/<name>/local/custom-gcl.
local function getCustomGclPath()
	local paths = vim.fn.systemlist({
		"git",
		"-C",
		cwd,
		"rev-parse",
		"--show-toplevel",
		"--path-format=absolute",
		"--git-common-dir",
	})
	if vim.v.shell_error ~= 0 then
		return "golangci-lint"
	end

	for _, root in ipairs({ paths[1], vim.fs.dirname(paths[2]) }) do
		local bin = root .. "/local/custom-gcl"
		if vim.fn.executable(bin) == 1 then
			return bin
		end
	end

	return "golangci-lint"
end

--- @class vim.lsp.Config
return {
	cmd = {
		"golangci-lint-langserver",
	},
	filetypes = { "go", "gomod" },
	init_options = {
		command = {
			getCustomGclPath(),
			"run",
			"--output.json.path",
			"stdout",
			"--show-stats=false",
		},
	},
	root_markers = {
		".golangci.yml",
		".golangci.yaml",
		".golangci.toml",
		".golangci.json",
		"go.work",
		"go.mod",
		".git",
	},
}
