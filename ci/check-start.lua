local timeout_ms = 20 * 60 * 1000

local failures = {}
local treesitter_pending = 0
local mason_done = false

local function load_without_preload(name)
	for i = 2, #package.loaders do
		local loader = package.loaders[i](name)
		if type(loader) == "function" then
			return loader(name)
		end
	end
	error("module not found: " .. name)
end

package.preload["nvim-treesitter"] = function(name)
	local mod = load_without_preload(name)
	local install = mod.install
	mod.install = function(...)
		local task = install(...)
		treesitter_pending = treesitter_pending + 1
		task:await(function(err, ok)
			treesitter_pending = treesitter_pending - 1
			if err or not ok then
				table.insert(failures, "treesitter install failed: " .. tostring(err or "see messages"))
			end
		end)
		return task
	end
	return mod
end

vim.api.nvim_create_autocmd("User", {
	pattern = "MasonToolsUpdateCompleted",
	once = true,
	callback = function()
		mason_done = true
	end,
})

local function errors()
	local found = vim.list_extend({}, failures)
	local messages = vim.fn.execute("messages")
	if messages:match("E%d+:") or messages:match("[Ee]rror") or messages:match("stack traceback") then
		table.insert(found, vim.trim(messages))
	end
	local ok, snacks = pcall(require, "snacks")
	if ok and snacks.notifier then
		for _, n in ipairs(snacks.notifier.get_history()) do
			if n.level == "error" then
				table.insert(found, n.msg)
			end
		end
	end
	return found
end

local function settled()
	return (mason_done and treesitter_pending == 0) or #errors() > 0
end

local function finish()
	local found = errors()
	if not mason_done then
		table.insert(found, "Mason installs did not finish")
	end
	if treesitter_pending > 0 then
		table.insert(found, "treesitter installs did not finish")
	end
	if #found == 0 then
		io.stdout:write("nvim started clean\n")
		vim.cmd("qall!")
	else
		io.stdout:write("nvim started with errors:\n" .. table.concat(found, "\n") .. "\n")
		vim.cmd("cquit 1")
	end
end

vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		vim.schedule(function()
			vim.wait(timeout_ms, settled, 500)
			vim.defer_fn(finish, 1000)
		end)
	end,
})
