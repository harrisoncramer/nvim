-- Launch or attach to a running Javascript process
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
      name = "Vitest Debug",
      type = "pwa-node",
      request = "launch",
      autoAttachChildProcesses = true,
      runtimeArgs = { "${workspaceFolder}/node_modules/.bin/vitest", "--no-threads", "--inspect-brk", "${file}" },
      skipFiles = { "<node_internals>/**", "**/node_modules/**" },
      console = "integratedTerminal",
      integratedTerminalOptions = "neverOpen",
      rootPath = "${workspaceFolder}",
      cwd = "${workspaceFolder}",
    }
    -- {
    --   name = "Vitest Debug (Breakpoints Not Respected)",
    --   type = "pwa-node",
    --   request = "launch",
    --   autoAttachChildProcesses = true,
    --   runtimeExecutable = "node",
    --   runtimeArgs = { "${workspaceFolder}/node_modules/vitest/vitest.mjs", "--inspect-brk", "${file}" },
    --   skipFiles = { "<node_internals>/**", "**/node_modules/**" },
    --   console = "integratedTerminal",
    --   integratedTerminalOptions = "neverOpen",
    --   rootPath = "${workspaceFolder}",
    --   cwd = "${workspaceFolder}",
    -- }
  }
end

local chrome_debugger = {
  type = "pwa-chrome",
  request = "launch",
  name = "Chrome",
  webRoot = "${workspaceFolder}",
}

local function vue(dap)
  dap.configurations.vue = {
    chrome_debugger
  }
end

local function javascriptreact(dap)
  dap.configurations.javascriptreact = {
    chrome_debugger
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
    -- Build the binary (go build -gcflags=all="-N -l") and run it + pick it
    {
      type = "go",
      name = "Attach (Pick Process)",
      mode = "local",
      request = "attach",
      processId = require('plugins.dap.utils').pick_process,
    },
    {
      type = "go",
      name = "Attach (127.0.0.1:9080)",
      mode = "remote",
      request = "attach",
      port = "9080"
    },
  }
end

return {
  javascript = javascript,
  javascriptreact = javascriptreact,
  vue = vue,
  go = go
}
