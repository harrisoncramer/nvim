local u = require("functions.utils")
local async_ok, async = pcall(require, "plenary.async")
local job_okay, job = pcall(require, 'plenary.job')

-- Install Golang's Debugger if it doesn't exist
local delve = function()
  local d = u.get_home() .. "/go/bin/dlv"
  if vim.fn.filereadable(d) == 0 then
    if not async_ok or not job_okay then
      require("notify")("Plenary not installed, cannot install Delve", "error")
      return
    end

    async.run(function()
      require("notify")("Installing Delve...", "info")
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
end

-- Install NodeJS Debugger if it doesn't exist
local node = function()
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
end

return {
  delve = delve,
  node = node,
}
