vim.keymap.set("n", "<localleader>j", function()
	vim.cmd("startinsert")
	vim.api.nvim_feedkeys("```javascript", "i", false)
end, {})
