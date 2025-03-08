local u = require("functions.utils")

vim.keymap.set("n", "<esc>", ":q<CR>", merge(local_keymap_opts, { desc = "Close the window" }))

vim.keymap.set("n", "cc", function()
	vim.cmd(":Git commit --quiet")
end, merge(local_keymap_opts, { desc = "Commit changes" }))

vim.keymap.set("n", "ca", function()
	vim.cmd(":Git commit --quiet --amend")
end, merge(local_keymap_opts, { desc = "Amend commit" }))

vim.keymap.set("n", "d", function()
	local sha = u.get_word_under_cursor()
	vim.print(sha)
	vim.api.nvim_feedkeys(string.format(":DiffviewOpen %s~1..%s", sha, sha), "n", false)
	u.press_enter()
end, merge(local_keymap_opts, { desc = "Diff changes in commit" }))

vim.keymap.set("n", "D", function()
	print("hi")
	local sha = u.get_word_under_cursor()
	vim.print(sha)
	vim.api.nvim_feedkeys(string.format(":DiffviewOpen origin/staging...%s", sha), "n", false)
	u.press_enter()
end, merge(local_keymap_opts, { desc = "Diff changes in commit against origin" }))
