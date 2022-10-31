vim.cmd([[
  let test#strategy = "neovim"
  let g:test#echo_command = 0
  let test#neovim#term_position = "vert"
  let g:test#javascript#runner = 'vitest'
  let g:test#javascript#vitest#file_pattern = '\v(__tests__/.*|(spec|test))\.(jsx|ts|tsx|js)$'
]])

local map_opts = { noremap = true, silent = true, nowait = true }

local with_flags = function(fn)
  return function()
    local ft = vim.bo.ft

    local flags = ""
    if ft == "go" then
      flags = "--v"
    else
    end

    fn(flags)
  end
end

vim.keymap.set(
  "n",
  "<localleader>tr",
  with_flags(function(flags)
    vim.cmd("let g:test#neovim#start_normal = 0")
    vim.cmd(":TestNearest" .. flags)
  end),
  map_opts
)

vim.keymap.set(
  "n",
  "<localleader>tw",
  with_flags(function(flags)
    vim.cmd("let g:test#neovim#start_normal = 1")
    vim.cmd(":TestNearest --watch " .. flags)
  end),
  map_opts
)

vim.keymap.set(
  "n",
  "<localleader>tfr",
  with_flags(function(flags)
    vim.cmd(":TestFile " .. flags)
  end),
  map_opts
)

vim.keymap.set(
  "n",
  "<localleader>tfw",
  with_flags(function(flags)
    vim.cmd(":TestFile --watch " .. flags)
  end),
  map_opts
)
