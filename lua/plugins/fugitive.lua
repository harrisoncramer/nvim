local u = require("functions.utils")

local function jump_next()
  vim.api.nvim_feedkeys(":silent! /^[?,M,A,D,U] ", "n", false)
  u.press_enter()
  vim.api.nvim_feedkeys(":noh", "n", false)
  u.press_enter()
end

local function jump_prev()
  vim.api.nvim_feedkeys(":silent! ?^[?,M,A,D,U] ", "n", false)
  u.press_enter()
  vim.api.nvim_feedkeys(":noh", "n", false)
  u.press_enter()
end

local git_push = function()
  local async_job, job = pcall(require, 'plenary.job')
  if not async_job then
    require("notify")("Plenary is not installed!", "error")
  end

  local push_job = job:new({
    command = 'git',
    args = { 'push' },
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        require("notify")("Could not push!", "error")
        return
      else
        require("notify")("Pushed.", "info")
      end
    end,
  })

  local isSubmodule = vim.fn.trim(vim.fn.system("git rev-parse --show-superproject-working-tree"))
  if isSubmodule == "" then
    push_job:start()
  else
    vim.fn.confirm("Push to origin/main branch for submodule?")
    push_job:start()
  end
end

local toggle_status = function()
  local ft = vim.bo.filetype
  if ft == "fugitive" then
    vim.api.nvim_command("bd")
  else
    local fugitive_tab = u.get_tab_by_buf_name("fugitive", true)
    if fugitive_tab ~= -1 then
      vim.api.nvim_set_current_tabpage(fugitive_tab)
    end
    vim.api.nvim_command("silent! :Git")
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>T", false, true, true), "n", false)
    jump_next()
  end
end

return {
  "tpope/vim-fugitive",
  config = function()
    local map_opts = { noremap = true, silent = true, nowait = true, buffer = false }
    vim.keymap.set("n", "<leader>gs", toggle_status, map_opts)
    vim.keymap.set("n", "<leader>gP", git_push, map_opts)
  end,
  dependencies = { "nvim-lua/plenary.nvim" },
  jump_next = jump_next,
  jump_prev = jump_prev,
}
