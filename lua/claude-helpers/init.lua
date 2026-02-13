vim.keymap.set(
	"n",
	"<C-a><C-i>",
	require("claude-helpers.linear").enrich_issue,
	vim.tbl_extend("force", global_keymap_opts, { desc = "Linear investigate" })
)

vim.keymap.set("n", "<C-a><C-r>", function()
	require("git-helpers").branch_input(function(branch)
		require("claude-helpers.review").review_changes(branch)
	end)
end, merge(global_keymap_opts, { desc = "Send diff of current branch to code companion" }))
