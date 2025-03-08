local M = {}

-- Default mapping options
local map_opts = { noremap = true, silent = true, nowait = true, buffer = false }
_G.map_opts = { noremap = true, silent = true, nowait = true, buffer = false }

local w = require("functions.work")
local u = require("functions.utils")
local lsp = require("functions.lsp")
vim.cmd.source("~/.config/nvim/lua/settings.vim")

-- Splits and tabs
vim.keymap.set("n", "ss", ":split<Return>", { unpack(map_opts), desc = "Horizontal split" })
vim.keymap.set("n", "sv", ":vsplit <Return>", { unpack(map_opts), desc = "Vertical split" })
vim.keymap.set("n", "sh", "<C-w>h", { unpack(map_opts), desc = "Move to the left split" })
vim.keymap.set("n", "sj", "<C-w>j", { unpack(map_opts), desc = "Move to the bottom split" })
vim.keymap.set("n", "sk", "<C-w>k", { unpack(map_opts), desc = "Move to the top split" })
vim.keymap.set("n", "sl", "<C-w>l", { unpack(map_opts), desc = "Move to the right split" })
vim.keymap.set("n", "sq", "<C-w>q", { unpack(map_opts), desc = "Close the current split" })
vim.keymap.set("n", "<leader>tn", ":tabnext<CR>", { unpack(map_opts), desc = "Next tab" })
vim.keymap.set("n", "<leader>tp", ":tabprev<CR>", { unpack(map_opts), desc = "Previous tab" })
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { unpack(map_opts), desc = "Close the current tab" })
vim.keymap.set("n", "<C-t>", "<C-^>", { unpack(map_opts), desc = "Switch to the alternate buffer" })

-- Copy/yank
vim.keymap.set("n", "ya", ":silent %y<CR>", { unpack(map_opts), desc = "Copy the entire file" })

-- Movement
vim.keymap.set("n", "*", ":keepjumps normal! mi*`i<CR>", { unpack(map_opts), desc = "Search on current word" })

-- File Operations
vim.keymap.set("n", "H", function()
	vim.cmd("silent! w")
end, { unpack(map_opts), desc = "Save the current file" })
vim.keymap.set("n", "[<space>", u.blank_line_above, { unpack(map_opts), desc = "Insert a blank line above" })
vim.keymap.set("n", "]<space>", u.blank_line_below, { unpack(map_opts), desc = "Insert a blank line below" })
vim.keymap.set("n", "[e", u.move_line_up, { unpack(map_opts), desc = "Move the current line up" })
vim.keymap.set("n", "]e", u.move_line_down, { unpack(map_opts), desc = "Move the current line down" })

-- Copy to clipboasrd
vim.keymap.set("n", "<leader>yd", u.copy_relative_dir, { unpack(map_opts), desc = "Copy the relative directory" })
vim.keymap.set("n", "<leader>yD", u.copy_absolute_dir, { unpack(map_opts), desc = "Copy the absolute directory" })
vim.keymap.set("n", "<leader>yF", u.copy_relative_filepath, { unpack(map_opts), desc = "Copy the relative file path" })
vim.keymap.set("n", "<leader>yf", u.copy_file_name, { unpack(map_opts), desc = "Copy the file name" })

-- Center the view after jumping up/down
vim.keymap.set("n", "<C-u>", "<C-u>zz", { unpack(map_opts), desc = "Center the view after jumping up" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { unpack(map_opts), desc = "Center the view after jumping down" })

-- Failures
vim.keymap.set("n", "<leader>fb", w.get_build_failures, { unpack(map_opts), desc = "Get build failures" })
vim.keymap.set("n", "<leader>fa", lsp.send_failures_to_qf, { unpack(map_opts), desc = "Send failures to quickfix" })
vim.keymap.set(
	"n",
	"gx",
	":silent! execute '!open ' . shellescape(expand('<cfile>'), 1)<CR>",
	{ unpack(map_opts), desc = "Open link under cursor" }
)

return M
