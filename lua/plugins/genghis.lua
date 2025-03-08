vim.keymap.set("n", "<leader>fr", function()
	require("genghis").renameFile()
end, merge(global_keymap_opts, { desc = "Rename file" }))

vim.keymap.set("n", "<leader>fo", function()
	require("genghis").showInSystemExplorer()
end, merge(global_keymap_opts, { desc = "Show in system explorer" }))

vim.keymap.set("n", "<leader>ft", function()
	require("genghis").trashFile()
end, merge(global_keymap_opts, { desc = "Trash file" }))

vim.keymap.set("n", "<leader>fx", function()
	require("genghis").chmodx()
end, merge(global_keymap_opts, { desc = "Change file permissions" }))

return {
	"chrisgrieser/nvim-genghis",
	opts = {
		trashCmd = "trash",
		icons = {
			chmodx = "󰒃",
			copyPath = "󰅍",
			copyFile = "󱉥",
			duplicate = "",
			file = "󰈔",
			move = "󰪹",
			new = "󰝒",
			rename = "󰑕",
			trash = "󰩹",
		},
	},
	successNotifications = false,
}
