local u = require("functions.utils")
local M = {}

M.get_component_references = function()
	local bufName = vim.api.nvim_buf_get_name(0)
	local filename = u.basename(bufName)
	local componentParts = u.split(filename, ".vue")
	local component = componentParts[1]
	local componentStart = "<" .. component
	_ = componentStart
	-- TODO: Fix if we need Vue again
	-- local fzfLua = require("fzf-lua")
	-- fzfLua.grep({ search = componentStart })
end

M.make_or_jump_to_test_file = function()
	local fp = u.copy_relative_filepath(true)
	local file_path = fp:gsub(".vue", ".test.js"):gsub("src/", "")
	local path = "test/specs/" .. file_path
	vim.cmd(string.format("e %s", path))
	u.replace_text_with_file("test_templates")
end

M.import_from_vue = function(recurse)
	local ok = u.jump_to_line("from 'vue'")
	if ok then
		vim.api.nvim_feedkeys("f}h", "n", false)
		return
	end

	u.jump_to_line("<script ")
	vim.api.nvim_feedkeys("oimport {  } from 'vue'", "i", false)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "n", false)
	vim.schedule(function()
		if recurse then -- If the previous line did not exist, we just run the shortcut again!
			M.import_from_vue(false)
		end
	end)
end

-- Gets vue "reference" to current component (searches for <ComponentName) in telescope
vim.keymap.set("n", "<localleader>vr", function()
	M.get_component_references()
end, unpack({ local_keymap_opts, description = "Get references to component" }))

vim.keymap.set(
	"n",
	"<localleader>tj",
	M.make_or_jump_to_test_file,
	unpack({ local_keymap_opts, description = "Make or jump to test file" })
)

vim.keymap.set("n", "<localleader>vi", function()
	M.import_from_vue(true)
end, unpack({ local_keymap_opts, description = "Import from Vue" }))

return M
