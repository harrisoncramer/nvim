local cwd = vim.fn.getcwd()
local isChariot = string.match(cwd, "/Users/harrisoncramer/chariot/chariot")
local isFoxhunt = string.match(cwd, "/Users/harrisoncramer/Desktop/foxhunt%-go")

-- Resolve the repo's custom golangci-lint binary, handling worktrees where the
-- binary lives under .worktrees/<name>/local/custom-gcl.
local function customGclFor(base)
	local worktree = string.match(cwd, "%.worktrees/([^/]+)")
	if worktree then
		return vim.fn.expand(base .. "/.worktrees/" .. worktree .. "/local/custom-gcl")
	end
	return vim.fn.expand(base .. "/local/custom-gcl")
end

local function getCustomGclPath()
	if isChariot then
		return customGclFor("~/chariot/chariot")
	elseif isFoxhunt then
		return customGclFor("~/Desktop/foxhunt-go")
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
