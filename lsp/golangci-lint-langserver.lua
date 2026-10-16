local cwd = vim.fn.getcwd()
local homePattern = vim.pesc(vim.env.HOME)
local isChariot = string.match(cwd, homePattern .. "/chariot/chariot")
local isFoxhunt = string.match(cwd, homePattern .. "/Desktop/foxhunt%-go")
local isWeave = string.match(cwd, homePattern .. "/weave")
local isClaudeManager = string.match(cwd, homePattern .. "/tmux%-claude%-agents")

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
	elseif isWeave then
		return customGclFor("~/weave")
	elseif isClaudeManager then
		return customGclFor("~/tmux-claude-agents")
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
