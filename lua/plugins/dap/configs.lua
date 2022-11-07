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
    -- {
    --   type = "node2",
    --   request = "attach",
    --   name = "Debug Test (Vitest)",
    --   cwd = vim.fn.getcwd(),
    --   autoAttachChildProcesses = true,
    --   skipFiles = { "<node_internals>/**", "**/node_modules/**" },
    --   program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
    --   args = { "run", "${relativeFile}" },
    --   -- smartStep = true,
    --   console = "integratedTerminal"
    -- }
  }
end

-- Attach to a Chrome browser running in debug mode
local chrome = {
  name = 'Chrome',
  type = 'chrome',
  request = 'attach',
  program = 'app.js',
  cwd = vim.fn.getcwd(),
  sourceMaps = true,
  protocol = 'inspector',
  port = 9222,
  outDir = "${workspaceRoot}/dist",
  webRoot = "${workspaceFolder}",
}

local firefox = {
  name = 'Firefox',
  type = 'firefox',
  request = 'attach',
  reAttach = true,
  sourceMaps = true,
  port = 9222,
  url = "https://app.crossbeam-dev.com",
  webRoot = '${workspaceFolder}/src',
  firefoxExecutable = '/usr/bin/firefox'
}

local function vue(dap)
  dap.configurations.vue = {
    chrome,
    firefox
  }
end

local function javascriptreact(dap)
  dap.configurations.javascriptreact = {
    chrome,
    firefox,
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
      name = "Attach",
      mode = "local",
      request = "attach",
      processId = require('plugins.dap.utils').pick_process,
    },
  }
end

return {
  javascript = javascript,
  javascriptreact = javascriptreact,
  vue = vue,
  go = go
}
