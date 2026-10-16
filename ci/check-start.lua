local timeout_ms = 20 * 60 * 1000

local failures = {}
local treesitter_pending = 0
local mason_done = false

local function record(msg)
	table.insert(failures, vim.trim(tostring(msg)))
end

for _, name in ipairs({ "nvim_err_write", "nvim_err_writeln" }) do
	local original = vim.api[name]
	vim.api[name] = function(msg)
		record(msg)
		return original(msg)
	end
end

local echo = vim.api.nvim_echo
vim.api.nvim_echo = function(chunks, history, opts)
	if opts and opts.err then
		record(table.concat(vim.tbl_map(function(chunk)
			return chunk[1]
		end, chunks)))
	end
	return echo(chunks, history, opts)
end

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

local function lazy_failures()
	local found = {}
	local ok, config = pcall(require, "lazy.core.config")
	if not ok then
		return found
	end
	for name, plugin in pairs(config.plugins) do
		if not plugin.virtual and not plugin._.installed then
			table.insert(found, name .. " is not installed")
		end
		for _, task in ipairs(plugin._.tasks or {}) do
			if task:has_errors() then
				table.insert(found, name .. " " .. task.name .. " failed: " .. task:output(vim.log.levels.ERROR))
			end
		end
	end
	return found
end

local function errors()
	local found = vim.list_extend(lazy_failures(), failures)
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
