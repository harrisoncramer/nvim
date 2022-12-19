local adapters = require("plugins.dap.adapters")
local configurations = require("plugins.dap.configs")
local mason_dap_ok, mason_dap = pcall(require, "mason-nvim-dap")

local dap_ok, dap = pcall(require, "dap")
local dap_ui_ok, ui = pcall(require, "dapui")

if not (dap_ok and dap_ui_ok and mason_dap_ok) then
  require("notify")("nvim-dap, mason-nvim-dap, or dap-ui not installed!", "warning")
  return
end

dap.set_log_level("TRACE")

-- ╭──────────────────────────────────────────────────────────╮
-- │ Debuggers                                                │
-- ╰──────────────────────────────────────────────────────────╯
-- We need the actual programs to connect to running instances of our code.
-- Debuggers are installed via https://github.com/jayp0521/mason-nvim-dap.nvim
mason_dap.setup({
  ensure_installed = { "delve", "node2" }
})

-- ╭──────────────────────────────────────────────────────────╮
-- │ Adapters                                                 │
-- ╰──────────────────────────────────────────────────────────╯
-- Neovim needs a debug adapter with which it can communicate. Neovim can either
-- launch the debug adapter itself, or it can attach to an existing one.
-- To tell Neovim if it should launch a debug adapter or connect to one, and if
-- so, how, you need to configure them via the `dap.adapters` table.
adapters.setup(dap)

-- ╭──────────────────────────────────────────────────────────╮
-- │ Configuration                                            │
-- ╰──────────────────────────────────────────────────────────╯
-- In addition to launching (possibly) and connecting to a debug adapter, Neovim
-- needs to instruct the adapter itself how to launch and connect to the program
-- that you are trying to debug (the debugee).
configurations.setup(dap)


-- ╭──────────────────────────────────────────────────────────╮
-- │ Keybindings + UI                                         │
-- ╰──────────────────────────────────────────────────────────╯
vim.fn.sign_define('DapBreakpoint', { text = '🐞' })
vim.keymap.set("n", "<localleader>ds", function()
  dap.continue()
  ui.toggle({})
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>=", false, true, true), "n", false)
end)

vim.keymap.set("n", "<localleader>dl", require("dap.ui.widgets").hover)
vim.keymap.set("n", "<localleader>dc", dap.continue)
vim.keymap.set("n", "<localleader>db", dap.toggle_breakpoint)
vim.keymap.set("n", "<localleader>dn", dap.step_over)
vim.keymap.set("n", "<localleader>di", dap.step_into)
vim.keymap.set("n", "<localleader>do", dap.step_out)
vim.keymap.set("n", "<localleader>dC", function()
  dap.clear_breakpoints()
  require("notify")("Breakpoints cleared", "warn")
end)

-- How to get current adapter config? Could restart with current arguments
vim.keymap.set("n", "<localleader>dr", function()
  dap.terminate()
  vim.defer_fn(
    function()
      dap.continue()
    end,
    300)
end)

vim.keymap.set("n", "<localleader>de", function()
  dap.clear_breakpoints()
  ui.toggle({})
  dap.terminate()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>=", false, true, true), "n", false)
  require("notify")("Debugger session ended", "warn")
end)

-- UI Settings
ui.setup({
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  expand_lines = vim.fn.has("nvim-0.7"),
  layouts = {
    {
      elements = {
        "scopes",
      },
      size = 0.3,
      position = "right"
    },
    {
      elements = {
        "repl",
        "breakpoints"
      },
      size = 0.3,
      position = "bottom",
    },
  },
  floating = {
    max_height = nil,
    max_width = nil,
    border = "single",
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil,
  },
})
