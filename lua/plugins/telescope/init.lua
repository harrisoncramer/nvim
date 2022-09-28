local actions = require("telescope.actions")
local state = require("telescope.actions.state")
local f = require("functions")
local u = require("functions.utils")
local fb_actions = require("telescope").extensions.file_browser.actions
local telescope = require("telescope")

local builtin = require("telescope.builtin")

-- Utility functions for file_browser extension
local function FbOpen(entry, open_file)
	local entry_path = u.dirname(entry)
	require("telescope").extensions.file_browser.file_browser({ path = entry_path })
	if open_file then
		vim.api.nvim_input(u.basename(entry))
	end
end

local function OpenInFileBrowser(prompt_bufnr)
	actions._close(prompt_bufnr, true)
	local entry = state.get_selected_entry()[1]
	FbOpen(entry, true)
end

local function OpenFileInFileBrowser()
	local file_path = vim.fn.expand("%")
	FbOpen(file_path, true)
end

local function OpenFolderInFileBrowser()
	local file_path = vim.fn.expand("%")
	FbOpen(file_path, false)
end

-- Functions for telescope
local function live_grep()
	builtin.live_grep()
end

local function git_files()
	local ok = pcall(builtin.git_files)
	if not ok then
		require("telescope.builtin").find_files()
	end
end

local function oldfiles()
	builtin.oldfiles()
end

local function git_commits()
	builtin.git_commits()
end

local function git_branches()
	builtin.git_branches()
end

local function grep_string()
	local word = vim.fn.expand("<cword>")
	builtin.grep_string()
	vim.api.nvim_feedkeys(word, "i", false)
end

local function git_files_string()
	local word = vim.fn.expand("<cword>")
	builtin.git_files()
	vim.api.nvim_feedkeys(word, "i", false)
end

local function git_files_string_visual()
	local text = u.get_visual_selection()
	vim.api.nvim_input("<esc>")
	if text[1] == nil then
		print("No appropriate visual selection found")
	else
		builtin.git_files()
		vim.api.nvim_input(text[1])
	end
end

local function grep_string_visual()
	local text = u.get_visual_selection()
	vim.api.nvim_input("<esc>")
	if text[1] == nil then
		print("No appropriate visual selection found")
	else
		builtin.grep_string()
		vim.api.nvim_input(text[1])
		vim.api.nvim_feedkeys(text, "i", false)
	end
end

local function current_buffer_fuzzy_find()
	require("telescope.builtin").current_buffer_fuzzy_find()
end

local function SeeCommitChangesInDiffview(prompt_bufnr)
	actions.close(prompt_bufnr)
	local value = state.get_selected_entry(prompt_bufnr).value
	vim.cmd("DiffviewOpen " .. value .. "~1.." .. value)
end

local function CheckoutAndRestore(prompt_bufnr)
	vim.cmd("Obsession")
	actions.git_checkout(prompt_bufnr)
	f.create_or_source_obsession()
end

local function CompareWithCurrentBranchInDiffview(prompt_bufnr)
	actions.close(prompt_bufnr)
	local value = state.get_selected_entry(prompt_bufnr).value
	vim.cmd("DiffviewOpen " .. value)
end

local function CopyTextFromPreview(prompt_bufnr)
	local selection = require("telescope.actions.state").get_selected_entry()
	local text = vim.fn.trim(selection["text"])
	vim.fn.setreg('"', text)
	actions.close(prompt_bufnr)
end

local function CopyCommitHash(prompt_bufnr)
	local selection = require("telescope.actions.state").get_selected_entry()
	vim.fn.setreg('"', selection.value)
	actions.close(prompt_bufnr)
end

telescope.setup({
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
		file_browser = {
			hijack_netrw = true,
			hide_parent_dir = true,
			mappings = {
				i = {
					["-"] = fb_actions.goto_parent_dir,
					["<C-e>"] = fb_actions.create,
					["<C-d>"] = fb_actions.remove,
					["<C-r>"] = function(bufnr)
						fb_actions.rename(bufnr)
					end,
					["<C-x>"] = fb_actions.move,
				},
			},
		},
	},
	defaults = {
		file_ignore_patterns = { "node_modules", "package%-lock.json" },
		mappings = {
			i = {
				["<esc>"] = actions.close,
				["<C-j>"] = actions.cycle_history_next,
				["<C-k>"] = actions.cycle_history_prev,
			},
		},
	},
	pickers = {
		live_grep = {
			only_sort_text = true,
			prompt_prefix = " ",
			mappings = {
				i = {
					["<C-y>"] = CopyTextFromPreview,
					["<C-h>"] = OpenInFileBrowser,
				},
			},
		},
		git_files = {
			show_untracked = true,
			mappings = {
				i = {
					["<C-h>"] = OpenInFileBrowser,
				},
			},
		},
		git_branches = {
			prompt_prefix = " ",
			mappings = {
				i = {
					["<C-o>"] = CheckoutAndRestore,
					["<Enter>"] = CheckoutAndRestore,
				},
			},
		},
		oldfiles = {
			prompt_prefix = " ",
		},
		grep_string = {
			prompt_prefix = " ",
		},
		current_buffer_fuzzy_find = {
			previewer = false,
			sorting_strategy = "ascending",
			prompt_prefix = " ",
		},
		buffers = {
			hidden = true,
		},
		git_commits = {
			prompt_prefix = " ",
			mappings = {
				i = {
					["<C-y>"] = CopyCommitHash,
					["<C-o>"] = SeeCommitChangesInDiffview,
					["<C-c>"] = CompareWithCurrentBranchInDiffview,
				},
			},
		},
	},
})

vim.keymap.set("n", "<C-f>", live_grep, {})
vim.keymap.set("n", "<C-c>", current_buffer_fuzzy_find, {})
vim.keymap.set("n", "<C-j>", git_files, {})
vim.keymap.set("n", "<C-m>", telescope.extensions.file_browser.file_browser, { silent = true, noremap = true })
vim.keymap.set("n", "<leader>tr", oldfiles, {})
vim.keymap.set("n", "<leader>tgc", git_commits, {})
vim.keymap.set("n", "<leader>tgb", git_branches, {})
vim.keymap.set("n", "<leader>tF", grep_string, {})
vim.keymap.set("n", "<leader>tf", git_files_string, {})
vim.keymap.set("v", "<leader>tf", git_files_string_visual, {})
vim.keymap.set("v", "<leader>tF", grep_string_visual, {})
vim.keymap.set("n", "<C-h>", OpenFileInFileBrowser)
vim.keymap.set("n", "<leader>;;", OpenFolderInFileBrowser)

-- telescope.load_extension("fzf")
telescope.load_extension("file_browser")

-- Custom Pickers
require("plugins.telescope.pickers")
