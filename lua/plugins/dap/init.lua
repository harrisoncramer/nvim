-- local debugger_installs = require("plugins.dap.debugger_installs")
local adapters = require("plugins.dap.adapters")
local configurations = require("plugins.dap.configs")
local mason_dap_ok, mason_dap = pcall(require, "mason-nvim-dap")
local dap_vscode_ok, dap_vscode = pcall(require, "dap-vscode-js")

return {
  setup = function()
    local dap = require("dap")
    local ui = require("dapui")

    if not (mason_dap_ok and dap_vscode_ok) then
      return
    end

    -- ╭──────────────────────────────────────────────────────────╮
    -- │ Debuggers                                                │
    -- ╰──────────────────────────────────────────────────────────╯
    -- We need the actual programs to connect to running instances of our code.
    -- Debuggers are installed via https://github.com/jayp0521/mason-nvim-dap.nvim
    mason_dap.setup({
      ensure_installed = { "delve", "node2", "js" }
    })

    -- ╭──────────────────────────────────────────────────────────╮
    -- │ Adapters                                                 │
    -- ╰──────────────────────────────────────────────────────────╯
    -- Neovim needs a debug adapter with which it can communicate. Neovim can either
    -- launch the debug adapter itself, or it can attach to an existing one.
    -- To tell Neovim if it should launch a debug adapter or connect to one, and if
    -- so, how, you need to configure them via the `dap.adapters` table.

    adapters.setup(dap)

    -- The VSCode Debugger requires a special setup
    dap_vscode.setup({
      adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
      debugger_path = vim.fn.stdpath("data") .. "/mason/bin/js-debug-adapter", -- Path to VSCode Debugger
      debugger_cmd = { "js-debug-adapter" }
    })


    -- ╭──────────────────────────────────────────────────────────╮
    -- │ Configuration                                            │
    -- ╰──────────────────────────────────────────────────────────╯
    -- In addition to launching (possibly) and connecting to a debug adapter, Neovim
    -- needs to instruct the adapter itself how to launch and connect to the program
    -- that you are trying to debug (the debugee).

    configurations.javascript(dap)
    configurations.vue(dap)
    configurations.javascriptreact(dap)
    configurations.go(dap)

    -- Global DAP Settings
    dap.set_log_level("TRACE")
    vim.fn.sign_define('DapBreakpoint', { text = '🐞' })
    vim.keymap.set("n", "<localleader>ds", function()
      dap.continue()
      require("dapui").toggle()
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
    vim.keymap.set("n", "<localleader>de", function()
      dap.clear_breakpoints()
      ui.toggle()
      dap.close()
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
          size = 0.2,
          position = "right"
        },
        {
          elements = {
            "breakpoints",
            "stacks",
          },
          size = 0.2,
          position = "right",
        },
        {
          elements = {
            "repl",
          },
          size = 0.15,
          position = "bottom",
        },
      },
      floating = {
        max_height = nil, -- These can be integers or a float between 0 and 1.
        max_width = nil, -- Floats will be treated as percentage of your screen.
        border = "single", -- Border style. Can be "single", "double" or "rounded"
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      windows = { indent = 1 },
      render = {
        max_type_length = nil,
      },
    })
  end,
}
