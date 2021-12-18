local M = {}
M.setup = function(remap)
    remap {'n', '<C-z>', ':lua require("FTerm").toggle()<CR>'}
    remap {'t', '<C-z>', '<C-\\><C-n>:lua require("FTerm").toggle()<CR>'}
end
return M
