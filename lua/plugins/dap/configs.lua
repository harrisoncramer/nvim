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
      name = "Debug Package",
      request = "launch",
      program = "${fileDirname}",
    },
    {
      type = "go",
      name = "Attach",
      mode = "local",
      request = "attach",
      processId = require('dap.utils').pick_process,
    },
    {
      type = "go",
      name = "Attach remote",
      mode = "remote",
      request = "attach",
    },
    {
      type = "go",
      name = "Debug test",
      request = "launch",
      mode = "test",
      program = "${file}",
    },
    {
      type = "go",
      name = "Debug test (go.mod)",
      request = "launch",
      mode = "test",
      program = "./${relativeFileDirname}",
    }
  }
end

return {
  javascript = javascript,
  vue = vue,
  go = go
}
