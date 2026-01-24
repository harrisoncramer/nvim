vim.keymap.set(
	"n",
	"<C-a>i",
	require("claude-helpers.linear").enrich_issue,
	vim.tbl_extend("force", local_keymap_opts, { desc = "Linear investigate" })
)

vim.keymap.set(
	"n",
	"<C-a>o",
	require("claude-helpers.linear").code_picker,
	vim.tbl_extend("force", local_keymap_opts, { desc = "Linear investigate" })
)

vim.keymap.set("n", "<C-a>r", function()
	require("git-helpers").branch_input(function(branch)
		require("claude-helpers").review_changes(branch)
	end)
end, merge(global_keymap_opts, { desc = "Send diff of current branch to code companion" }))
