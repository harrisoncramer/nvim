vim.keymap.set(
	"n",
	"<leader>ai",
	require("claude-helpers.linear").enrich_issue,
	vim.tbl_extend("force", global_keymap_opts, { desc = "Linear investigate" })
)

vim.keymap.set(
	"n",
	"<leader>ao",
	require("claude-helpers.linear").code_picker,
	vim.tbl_extend("force", global_keymap_opts, { desc = "Linear investigate" })
)

vim.keymap.set("n", "<leader>ar", function()
	require("git-helpers").branch_input(function(branch)
		require("claude-helpers.review").review_changes(branch)
	end)
end, merge(global_keymap_opts, { desc = "Send diff of current branch to code companion" }))
