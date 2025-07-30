local M = {}

local w = require("functions.work")
local u = require("functions.utils")
local lsp = require("functions.lsp")

-- Splits and tabs
vim.keymap.set("n", "ss", ":split<Return>", merge(global_keymap_opts, { desc = "Horizontal split" }))
vim.keymap.set("n", "sv", ":vsplit <Return>", merge(global_keymap_opts, { desc = "Vertical split" }))
vim.keymap.set("n", "sh", "<C-w>h", merge(global_keymap_opts, { desc = "Move to the left split" }))
vim.keymap.set("n", "sj", "<C-w>j", merge(global_keymap_opts, { desc = "Move to the bottom split" }))
vim.keymap.set("n", "sk", "<C-w>k", merge(global_keymap_opts, { desc = "Move to the top split" }))
vim.keymap.set("n", "sl", "<C-w>l", merge(global_keymap_opts, { desc = "Move to the right split" }))
vim.keymap.set("n", "sq", "<C-w>q", merge(global_keymap_opts, { desc = "Close the current split" }))
vim.keymap.set("n", "<leader>tn", ":tabnext<CR>", merge(global_keymap_opts, { desc = "Next tab" }))
vim.keymap.set("n", "<leader>tp", ":tabprev<CR>", merge(global_keymap_opts, { desc = "Previous tab" }))
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", merge(global_keymap_opts, { desc = "Close the current tab" }))
vim.keymap.set("n", "<C-t>", "<C-^>", merge(global_keymap_opts, { desc = "Switch to the alternate buffer" }))

-- Force quit
vim.keymap.set("n", "ZX", ":qa!<CR>", merge(global_keymap_opts, { desc = "Force quit" }))

-- Rename word under cursor
vim.keymap.set("n", "&", function()
	vim.api.nvim_feedkeys(":keepjumps normal! mi*`i<CR>", "n", false)
	u.press_enter()
	vim.api.nvim_feedkeys(":%s//", "n", false)
end)

-- Copy/yank
vim.keymap.set("n", "<leader>ya", ":silent %y<CR>", merge(global_keymap_opts, { desc = "Copy the entire file" }))

-- Movement
vim.keymap.set("n", "*", ":keepjumps normal! mi*`i<CR>", merge(global_keymap_opts, { desc = "Search on current word" }))
vim.keymap.set("i", "<C-l>", "<Right>", merge(global_keymap_opts, { desc = "Move right in insert mode" }))
vim.keymap.set("i", "<C-h>", "<Left>", merge(global_keymap_opts, { desc = "Move left in insert mode" }))

-- File Operations
vim.keymap.set("n", "H", function()
	vim.cmd("silent! w")
end, merge(global_keymap_opts, { desc = "Save the current file" }))
vim.keymap.set("n", "[<space>", u.blank_line_above, merge(global_keymap_opts, { desc = "Insert a blank line above" }))
vim.keymap.set("n", "]<space>", u.blank_line_below, merge(global_keymap_opts, { desc = "Insert a blank line below" }))
vim.keymap.set("n", "[e", u.move_line_up, merge(global_keymap_opts, { desc = "Move the current line up" }))
vim.keymap.set("n", "]e", u.move_line_down, merge(global_keymap_opts, { desc = "Move the current line down" }))

-- Copy to clipboasrd
vim.keymap.set(
	"n",
	"<leader>yd",
	u.copy_relative_dir,
	merge(global_keymap_opts, { desc = "Copy the relative directory" })
)
vim.keymap.set(
	"n",
	"<leader>yD",
	u.copy_absolute_dir,
	merge(global_keymap_opts, { desc = "Copy the absolute directory" })
)
vim.keymap.set(
	"n",
	"<leader>yF",
	u.copy_relative_filepath,
	merge(global_keymap_opts, { desc = "Copy the relative file path" })
)
vim.keymap.set("n", "<leader>yf", u.copy_file_name, merge(global_keymap_opts, { desc = "Copy the file name" }))

-- Center the view after jumping up/down
vim.keymap.set("n", "<C-u>", "<C-u>zz", merge(global_keymap_opts, { desc = "Center the view after jumping up" }))
vim.keymap.set("n", "<C-d>", "<C-d>zz", merge(global_keymap_opts, { desc = "Center the view after jumping down" }))

-- Failures
vim.keymap.set("n", "<leader>fb", w.get_build_failures, merge(global_keymap_opts, { desc = "Get build failures" }))
vim.keymap.set(
	"n",
	"<leader>fa",
	lsp.send_failures_to_qf,
	merge(global_keymap_opts, { desc = "Send failures to quickfix" })
)
vim.keymap.set(
	"n",
	"gx",
	":silent! execute '!open ' . shellescape(expand('<cfile>'), 1)<CR>",
	merge(global_keymap_opts, { desc = "Open link under cursor" })
)

return M
