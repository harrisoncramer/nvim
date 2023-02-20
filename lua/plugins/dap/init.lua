return {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "jay-babu/mason-nvim-dap.nvim",
    "mfussenegger/nvim-dap",
    "mxsdev/nvim-dap-vscode-js",
  },
  config = function()
    local adapters = require("plugins.dap.adapters")
    local configurations = require("plugins.dap.configs")

    local mason_dap = require("mason-nvim-dap")
    local dap = require("dap")
    local ui = require("dapui")

    dap.set_log_level("TRACE")

    -- ╭──────────────────────────────────────────────────────────╮
    -- │ Debuggers                                                │
    -- ╰──────────────────────────────────────────────────────────╯
    -- We need the actual programs to connect to running instances of our code.
    -- Debuggers are installed via https://github.com/jayp0521/mason-nvim-dap.nvim,
    -- however that repo removed the VSCode debugger because Mason doesn't directly support
    -- it, so I forked it and added it back myself. The debugger requires a
    -- special adapter, seen in /lua/plugins/dap/adapters.lua
    mason_dap.setup({
      ensure_installed = { "delve", "node2", "js" },
      automatic_installation = true
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

    local function dap_start_debugging()
      dap.continue({})
      vim.cmd("tabedit %")
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-o>", false, true, true), "n", false)
      ui.toggle({})
    end

    vim.keymap.set("n", "<localleader>ds", dap_start_debugging)
    vim.keymap.set("n", "<localleader>dl", require("dap.ui.widgets").hover)
    vim.keymap.set("n", "<localleader>dc", dap.continue)
    vim.keymap.set("n", "<localleader>db", dap.toggle_breakpoint)
    vim.keymap.set("n", "<localleader>dn", dap.step_over)
    vim.keymap.set("n", "<localleader>di", dap.step_into)
    vim.keymap.set("n", "<localleader>do", dap.step_out)

    local function dap_clear_breakpoints()
      dap.clear_breakpoints()
      require("notify")("Breakpoints cleared", "warn")
    end

    vim.keymap.set("n", "<localleader>dC", dap_clear_breakpoints)

    -- TODO: How to get current adapter config? Could restart with current arguments
    local function dap_restart_current_session()
      dap.terminate()
      vim.defer_fn(
        function()
          dap.continue()
        end,
        300)
    end

    vim.keymap.set("n", "<localleader>dr", dap_restart_current_session)

    local function dap_end_debug()
      dap.clear_breakpoints()
      ui.toggle({})
      dap.terminate({}, { terminateDebuggee = true }, function()
        vim.cmd.tabclose()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>=", false, true, true), "n", false)
        require("notify")("Debugger session ended", "warn")
      end)
    end

    vim.keymap.set("n", "<localleader>de", dap_end_debug)

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
        -- max_height = nil,
        -- max_width = nil,
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
  end
}
