local neotest = require("neotest")
local map_opts = { noremap = true, silent = true, nowait = true }
local colors = require("colorscheme")

-- get neotest namespace (api call creates or returns namespace)
local neotest_ns = vim.api.nvim_create_namespace("neotest")
vim.diagnostic.config({
  virtual_text = {
    format = function(diagnostic)
      local message =
      diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
      return message
    end,
  },
}, neotest_ns)

require("neotest").setup({
  icons = {
    child_indent = "│",
    child_prefix = "├",
    collapsed = "─",
    expanded = "╮",
    failed = "✘",
    final_child_indent = " ",
    final_child_prefix = "╰",
    non_collapsible = "─",
    passed = " ✓",
    running = "◐",
    running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
    skipped = "○",
    unknown = ""
  },
  highlights = {
    adapter_name = "NeotestAdapterName",
    border = "NeotestBorder",
    dir = "NeotestDir",
    expand_marker = "NeotestExpandMarker",
    failed = "NeotestFailed",
    file = "NeotestFile",
    focused = "NeotestFocused",
    indent = "NeotestIndent",
    marked = "NeotestMarked",
    namespace = "NeotestNamespace",
    passed = "NeotestPassed",
    running = "NeotestRunning",
    select_win = "NeotestWinSelect",
    skipped = "NeotestSkipped",
    target = "NeotestTarget",
    test = "NeotestTest",
    unknown = "NeotestUnknown"
  },
  adapters = {
    require('neotest-vitest'),
    require('neotest-go')
  }
})

vim.api.nvim_set_hl(0, 'NeotestBorder', { fg = colors.fujiGray })
vim.api.nvim_set_hl(0, 'NeotestIndent', { fg = colors.fujiGray })
vim.api.nvim_set_hl(0, 'NeotestExpandMarker', { fg = colors.fujiGray })
vim.api.nvim_set_hl(0, 'NeotestDir', { fg = colors.fujiGray })
vim.api.nvim_set_hl(0, 'NeotestFile', { fg = colors.fujiGray })

vim.api.nvim_set_hl(0, 'NeotestFailed', { fg = colors.samuraiRed })
vim.api.nvim_set_hl(0, 'NeotestPassed', { fg = colors.springGreen })
vim.api.nvim_set_hl(0, 'NeotestSkipped', { fg = colors.carpYellow })
vim.api.nvim_set_hl(0, 'NeotestRunning', { fg = colors.carpYellow })
vim.api.nvim_set_hl(0, 'NeotestNamespace', { fg = colors.crystalBlue })
vim.api.nvim_set_hl(0, 'NeotestAdapterName', { fg = colors.oniViolet })

vim.keymap.set(
  "n",
  "<localleader>tfr",
  function()
    neotest.run.run(vim.fn.expand("%"))
    neotest.summary.open()
  end,
  map_opts
)

vim.keymap.set(
  "n",
  "<localleader>tr",
  function()
    neotest.run.run()
    neotest.summary.open()
  end,
  map_opts
)
