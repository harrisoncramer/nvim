local u = require("functions.utils")
local async_ok, async = pcall(require, "plenary.async")
local job_okay, job = pcall(require, 'plenary.job')

vim.keymap.set("n", "<localleader>dl", require("dap.ui.widgets").hover)

return {
  setup = function()
    local dap = require("dap")

    -- Install NodeJS Debugger if it doesn't exist
    local node_debug_folder = u.get_home() .. "/dev/microsoft/vscode-node-debug2"
    if vim.fn.isdirectory(node_debug_folder) == 0 then
      if not async_ok or not job_okay then
        require("notify")("Plenary not installed, cannot install NodeJS Debugger", "error")
        return
      end

      async.run(function()
        require("notify")("Installing NodeJS debugger", "info")
      end)

      local config_path = vim.fn.stdpath("config")
      local node_debugger_install = job:new({
        command = config_path .. "/scripts" .. "/install_node_debugger",
        args = {},
        on_exit = function(_, exit_code)
          if exit_code ~= 0 then
            require("notify")("Could not install node debugger", vim.log.levels.ERROR)
            return
          end
          require("notify")("Node debugger installed", vim.log.levels.INFO)
        end,
      })
      node_debugger_install:start()
    end

    -- Install Golang Debugger if it doesn't exist
    local delve = u.get_home() .. "/go/bin/dlv"
    if vim.fn.filereadable(delve) == 0 then
      if not async_ok or not job_okay then
        require("notify")("Plenary not installed, cannot install Delve", "error")
        return
      end

      async.run(function()
        require("notify")("Installing NodeJS debugger", "info")
      end)

      local delve_install = job:new({
        command = "go",
        args = { "install", "github.com/go-delve/delve/cmd/dlv@latest" },
        on_exit = function(_, exit_code)
          if exit_code ~= 0 then
            require("notify")("Could not install delve", vim.log.levels.ERROR)
            return
          end
          require("notify")("Delve installed", vim.log.levels.INFO)
        end,
      })

      delve_install:start()
    end

    -- Global DAP Settings
    dap.set_log_level("TRACE")
    vim.fn.sign_define('DapBreakpoint', { text = '🐞' })

    -- ╭──────────────────────────────────────────────────────────╮
    -- │ Javascript                                               │
    -- ╰──────────────────────────────────────────────────────────╯

    -- In addition to launching (possibly) and connecting to a debug adapter, Neovim
    -- needs to instruct the debug adapter itself how to launch and connect to the
    -- debugee. The debugee is the application you want to debug.

    -- Node
    dap.adapters.node2 = {
      type = 'executable';
      command = 'node',
      args = { vim.fn.stdpath "data" .. '/mason/packages/node-debug2-adapter/out/src/nodeDebug.js' };
    }

    -- Chrome
    dap.adapters.chrome = {
      type = 'executable',
      command = 'node',
      args = { vim.fn.stdpath "data" .. '/mason/packages/chrome-debug-adapter/out/src/chromeDebug.js' };
    }

    dap.configurations.javascript = {
      {
        type = 'node2';
        name = 'Node',
        request = 'launch';
        program = '${file}';
        cwd = vim.fn.getcwd();
        sourceMaps = true;
        protocol = 'inspector';
        console = 'integratedTerminal';
      },
      {
        type = 'chrome',
        name = 'Debug (Chrome)',
        request = 'attach',
        program = '${file}',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        port = 9222,
        webRoot = '${workspaceFolder}'
      },
    }

    dap.configurations.vue = {
      {
        type = 'chrome',
        name = 'Debug (Chrome)',
        request = 'attach',
        program = 'app.js',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        port = 9222,
        webRoot = "${worspaceFolder}",
      }
    }

    -- ╭──────────────────────────────────────────────────────────╮
    -- │ Golang                                                   │
    -- ╰──────────────────────────────────────────────────────────╯

    -- Using nvim-dap-go

    vim.keymap.set("n", "<localleader>ds", function()
      require("dapui").toggle()
      dap.continue()
    end)

    vim.keymap.set("n", "<localleader>dr", function()
      require("dapui").toggle()
      require("dap").run({
        type = "go",
        name = "Debug",
        request = "launch",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        args = function()
          local argument_string = vim.fn.input("Arguments: ")
          return vim.fn.split(argument_string, " ", true)
        end,
      })
    end)

    vim.keymap.set("n", "<localleader>dc", dap.continue)
    vim.keymap.set("n", "<localleader>db", dap.toggle_breakpoint)
    vim.keymap.set("n", "<localleader>dn", dap.step_over)
    vim.keymap.set("n", "<localleader>di", dap.step_into)
    vim.keymap.set("n", "<localleader>do", dap.step_out)
    vim.keymap.set("n", "<localleader>dC", dap.clear_breakpoints)
    vim.keymap.set("n", "<localleader>de", function()
      require("dapui").toggle()
      require("dap").close()
    end)

    -- Could be used to jump back/forth to a window with a specific name...

    -- vim.keymap.set("n", "<localleader>dl", function()
    --   local buf_name = u.get_current_buf_name()
    --   if buf_name == "DAP Scopes" then
    --     vim.api.nvim_feedkeys(
    --       vim.api.nvim_replace_termcodes("<C-w><C-p>", false, true, true),
    --       "n",
    --       false
    --     )
    --   end
    --   local win = u.get_win_by_buf_name("DAP Scopes")
    --   if win == -1 then
    --     return
    --   end
    --   vim.api.nvim_set_current_win(win)
    -- end)

    require("dapui").setup({
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
            "breakpoints",
            "stacks",
          },
          size = 0.3,
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
