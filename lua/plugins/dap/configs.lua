-- Launch or attach to a running Javascript/Typescript process
local jsOrTs = {
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
    cwd = vim.fn.getcwd(),
    program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
    args = { "--inspect-brk", "--threads", "false", "run", "${file}" },
    autoAttachChildProcesses = true,
    smartStep = true,
    console = "integratedTerminal",
    skipFiles = { "<node_internals>/**", "node_modules/**" },
  },
}

local function javascript(dap)
  dap.configurations.javascript = jsOrTs
end

local function typescript(dap)
  dap.configurations.typescript = jsOrTs
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
  typescript = typescript,
  vue = vue,
  go = go
}
