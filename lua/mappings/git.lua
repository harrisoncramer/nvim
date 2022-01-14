vim.cmd([[command! -nargs=1 Stash lua require("mappings.git").stash(<f-args>)]])

local M = {}
M.stash = function(name)
	vim.cmd(":! git stash -u -m " .. name)
end

return M
