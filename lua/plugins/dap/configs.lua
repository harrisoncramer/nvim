local function javascript(dap)
  dap.configurations.javascript = {
    {
      type = 'node2';
      name = 'Launch',
      request = 'launch';
      program = '${file}';
      cwd = vim.fn.getcwd();
      sourceMaps = true;
      protocol = 'inspector';
      console = 'integratedTerminal';
    },
    {
      type = 'node2';
      name = 'Attach',
      request = 'attach';
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
end

local function vue(dap)
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
end

local function javascriptreact(dap)
  dap.configurations.javascriptreact = {
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
end

local function go(dap)
  dap.configurations.go = {
    {
      type = "go",
      name = "Debug",
      request = "launch",
      program = "${file}",
    },
    {
      type = "go",
      name = "Debug test (go.mod)",
      request = "launch",
      mode = "test",
      program = "./${relativeFileDirname}",
    },
    -- To attach to a running Go process:
    -- 1. Build the binary: go build -gcflags=all="-N -l"
    -- 2. Run it
    -- 3. Use the pick_process function to see the PIDs of all processes
    -- and choose the one of the running process
    {
      type = "go",
      name = "Attach",
      mode = "local",
      request = "attach",
      processId = require('plugins.dap.utils').pick_process,
    },
    -- {
    --   type = "go",
    --   name = "Attach remote",
    --   mode = "remote",
    --   request = "attach",
    -- },
  }
end

return {
  javascript = javascript,
  javascriptreact = javascriptreact,
  vue = vue,
  go = go
}
