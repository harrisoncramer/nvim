local cwd = vim.fn.getcwd()
local isChariot = string.match(cwd, "/Users/harrisoncramer/chariot/chariot")

local function getCustomGclPath()
	if not isChariot then
		return "golangci-lint"
	end

	if string.match(cwd, "%.worktrees/[^/]+") then
		local worktree = string.match(cwd, "%.worktrees/([^/]+)")
		return vim.fn.expand("~/chariot/chariot/.worktrees/" .. worktree .. "/local/custom-gcl")
	else
		return vim.fn.expand("~/chariot/chariot/local/custom-gcl")
	end
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
