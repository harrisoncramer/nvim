local f = require("functions")

local toggleStatus = function()
	vim.cmd([[
  if buflisted(bufname('.git/index'))
      bd .git/index
  else
      Git
  endif
]])
end

return {
	setup = function(remap)
		vim.keymap.set("n", "<leader>gs", toggleStatus)
		if f.getOS() == "Linux" then
			remap({ "n", "<leader>gP", ":! git push <cr>" })
			remap({ "n", "<leader>go", ":! git open <cr>" })
		else
			remap({ "n", "<leader>gP", ":Git push<cr>" })
			remap({ "n", "<leader>go", ":Git open<cr>" })
		end
	end,
}
