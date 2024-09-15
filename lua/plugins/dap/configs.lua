-- Launch or attach to a running Javascript/Typescript process
local M = {}
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
    args = { "run", "${file}" },
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

local function get_go_args()
  local co = coroutine.running()
  vim.ui.input({ prompt = "Args: " }, function(input)
    local args = {}
    input = input or ""
    local i = 1
    local len = #input
    local in_quote = false
    local quote_char = ''
    local escaped = false
    local current_arg = ''

    while i <= len do
      local c = input:sub(i, i)
      if escaped then
        current_arg = current_arg .. c
        escaped = false
      elseif c == '\\' then
        escaped = true
      elseif in_quote then
        if c == quote_char then
          in_quote = false
          quote_char = ''
        else
          current_arg = current_arg .. c
        end
      elseif c == '"' or c == "'" then
        in_quote = true
        quote_char = c
      elseif c:match('%s') then
        if #current_arg > 0 then
          table.insert(args, current_arg)
          current_arg = ''
        end
      else
        current_arg = current_arg .. c
      end
      i = i + 1
    end
    if #current_arg > 0 then
      table.insert(args, current_arg)
    end

    coroutine.resume(co, args)
  end)
  return coroutine.yield()
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
    args = get_go_args,
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

local lua = {
  {
    type = 'nlua',
    request = 'attach',
    name = "Attach to running Neovim instance",
  }
}

return {
  setup = function(dap)
    dap.configurations = {
      javascript = jsOrTs,
      typescript = jsOrTs,
      javascriptreact = chrome_debugger,
      vue = chrome_debugger,
      go = go,
      lua = lua,
    }
  end,
}
