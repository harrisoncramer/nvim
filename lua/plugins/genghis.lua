local map_opts = { noremap = true, silent = false, nowait = true, buffer = false }

vim.keymap.set("n", "<leader>fr", function()
	require("genghis").renameFile()
end, map_opts)

vim.keymap.set("n", "<leader>fo", function()
	require("genghis").showInSystemExplorer()
end, map_opts)

vim.keymap.set("n", "<leader>ft", function()
	require("genghis").trashFile()
end, map_opts)

vim.keymap.set("n", "<leader>fx", function()
	require("genghis").chmodx()
end)

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
