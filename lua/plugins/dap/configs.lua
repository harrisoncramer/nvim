-- Launch or attach to a running Javascript/Typescript process
local jsOrTs = {
  {
    type = 'node2',
    name = 'Launch',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
  {
    type = 'node2',
    name = 'Attach',
    request = 'attach',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
  {
    name = "Vitest Debug",
    type = "pwa-node",
    request = "launch",
    cwd = vim.fn.getcwd(),
    program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
    args = { "--threads", "false", "run", "${file}" },
    autoAttachChildProcesses = true,
    smartStep = true,
    console = "integratedTerminal",
    skipFiles = { "<node_internals>/**", "node_modules/**" },
  },
}

local chrome_debugger = {
  type = "pwa-chrome",
  request = "launch",
  name = "Chrome",
  webRoot = "${workspaceFolder}",
}

local function get_arguments()
  local co = coroutine.running()
  if co then
    return coroutine.create(function()
      local args = {}
      vim.ui.input({ prompt = "Args: " }, function(input)
        args = vim.split(input or "", " ")
      end)
      coroutine.resume(co, args)
    end)
  else
    local args = {}
    vim.ui.input({ prompt = "Args: " }, function(input)
      args = vim.split(input or "", " ")
    end)
    return args
  end
end

local go = {
  {
    type = "go",
    name = "Debug",
    request = "launch",
    program = "${file}",
  },
  {
    type = "go",
    name = "Debug (Arguments)",
    request = "launch",
    program = "${file}",
    args = get_arguments,
  },
  {
    type = "go",
    name = "Debug Test (main)",
    request = "launch",
    mode = "test",
    program = "${file}",
  },
  {
    type = "go",
    name = "Debug Test (package)",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}",
  },
  -- Build the binary (go build -gcflags=all="-N -l") and run it + pick it
  {
    type = "go",
    name = "Attach To PID",
    mode = "local",
    request = "attach",
    processId = require('plugins.dap.utils').pick_process,
  },
  {
    type = "go",
    name = "Attach To Port (:9080)",
    mode = "remote",
    request = "attach",
    port = "9080"
  },
}

return {
  setup = function(dap)
    dap.configurations = {
      javascript = jsOrTs,
      typescript = jsOrTs,
      javascriptreact = chrome_debugger,
      vue = chrome_debugger,
      go = go,
    }
  end
}
