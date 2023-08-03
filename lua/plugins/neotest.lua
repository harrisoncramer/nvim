local u = require("functions.utils")
vim.api.nvim_create_autocmd("FileType", {
  pattern = "neotest-summary",
  callback = function()
    vim.wo.wrap = false
  end,
})
return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim",
    "marilari88/neotest-vitest",
    "nvim-neotest/neotest-go",
  },
  config = function()
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
      quickfix = {
        open = false,
        enabled = false,
      },
      status = {
        enabled = true,
        signs = true, -- Sign after function signature
        virtual_text = false
      },
      icons = {
        child_indent = "│",
        child_prefix = "├",
        collapsed = "─",
        expanded = "╮",
        failed = "✘",
        final_child_indent = " ",
        final_child_prefix = "╰",
        non_collapsible = "─",
        passed = "✓",
        running = "",
        running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
        skipped = "↓",
        unknown = ""
      },
      floating = {
        border = "rounded",
        max_height = 0.9,
        max_width = 0.9,
        options = {}
      },
      summary = {
        open = "botright vsplit | vertical resize 60",
        mappings = {
          attach = "a",
          clear_marked = "M",
          clear_target = "T",
          debug = "d",
          debug_marked = "D",
          expand = { "<CR>", "<2-LeftMouse>" },
          expand_all = "e",
          jumpto = "i",
          mark = "m",
          next_failed = "J",
          output = "o",
          prev_failed = "K",
          run = "r",
          run_marked = "R",
          short = "O",
          stop = "u",
          target = "t",
          watch = "w"
        },
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
    vim.api.nvim_set_hl(0, 'NeotestSkipped', { fg = colors.fujiGray })
    vim.api.nvim_set_hl(0, 'NeotestRunning', { fg = colors.carpYellow })
    vim.api.nvim_set_hl(0, 'NeotestNamespace', { fg = colors.crystalBlue })
    vim.api.nvim_set_hl(0, 'NeotestAdapterName', { fg = colors.oniViolet })

    vim.keymap.set(
      "n",
      "<localleader>tfr",
      function()
        neotest.run.run(vim.fn.expand("%"))
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

    vim.keymap.set(
      "n",
      "<localleader>to",
      function()
        neotest.output.open({ last_run = true, enter = true })
      end
    )


    vim.keymap.set(
      "n",
      "<localleader>tt",
      function()
        neotest.summary.toggle()
        u.resize_vertical_splits()
      end,
      map_opts
    )

    -- vim.keymap.set(
    --   "n",
    --   "<localleader>tn",
    --   neotest.jump.next,
    --   map_opts
    -- )
    --
    -- vim.keymap.set(
    --   "n",
    --   "<localleader>tp",
    --   neotest.jump.prev,
    --   map_opts
    -- )

    vim.keymap.set(
      "n",
      "<localleader>tl",
      function()
        neotest.run.run_last({ enter = true })
        neotest.output.open({ last_run = true, enter = true })
      end,
      map_opts
    )
  end
}
