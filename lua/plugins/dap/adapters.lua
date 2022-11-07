local function setup(dap)
  dap.adapters.node2 = {
    type = 'executable';
    command = 'node',
    args = { vim.fn.stdpath "data" .. '/mason/packages/node-debug2-adapter/out/src/nodeDebug.js' };
  }

  dap.adapters.chrome = {
    type = 'executable',
    command = 'node',
    args = { vim.fn.stdpath "data" .. '/mason/packages/chrome-debug-adapter/out/src/chromeDebug.js' };
  }

  dap.adapters.firefox = {
    type = 'executable',
    command = 'node',
    args = { vim.fn.stdpath "data" .. '/mason/packages/firefox-debug-adapter/dist/adapter.bundle.js' };
  }

  dap.adapters.go = function(callback, config)
    local stdout = vim.loop.new_pipe(false)
    local stderr = vim.loop.new_pipe(false)
    local handle
    local pid_or_err
    local host = config.host or "127.0.0.1"
    local port = config.port or "38697"
    local addr = string.format("%s:%s", host, port)

    if (config.request == "attach" and config.mode == "remote") then
      -- Not starting delve server automatically in "Attach remote."
      -- Will connect to delve server that is listening to [host]:[port] instead.
      -- Users can use this with delve headless mode:
      --
      -- dlv debug -l 127.0.0.1:38697 --headless ./cmd/main.go
      --
      local msg = string.format("connecting to server at '%s'...", addr)
      print(msg)
    else
      local opts = {
        stdio = { nil, stdout, stderr },
        args = { "dap", "-l", addr },
        detached = true
      }
      handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
        stdout:close()
        stderr:close()
        handle:close()
        if code ~= 0 then
          print('dlv exited with code', code)
        end
      end)
      assert(handle, 'Error running dlv: ' .. tostring(pid_or_err))
      stdout:read_start(function(err, chunk)
        assert(not err, err)
        if chunk then
          vim.schedule(function()
            require('dap.repl').append(chunk)
          end)
        end
      end)
      stderr:read_start(function(err, chunk)
        assert(not err, err)
        if chunk then
          vim.schedule(function()
            require('dap.repl').append(chunk)
          end)
        end
      end)
    end

    -- Wait for delve to start
    vim.defer_fn(
      function()
        callback({ type = "server", host = host, port = port })
      end,
      100)
  end

end

return {
  setup = setup
}
