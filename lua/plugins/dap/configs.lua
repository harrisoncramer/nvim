local function javascript(dap)
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
    -- 3. Get the process id of the process: ps aux | grep my-binary
    -- 4. Add the PID to this file
    {
      type = "go",
      name = "Attach",
      mode = "local",
      request = "attach",
      processId = 60642,
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
  vue = vue,
  go = go
}
