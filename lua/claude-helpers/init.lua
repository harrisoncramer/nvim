vim.keymap.set(
	"n",
	"<C-l>",
	require("claude-helpers.linear").select_issue,
	vim.tbl_extend("force", global_keymap_opts, { desc = "Select Linear issue" })
)
