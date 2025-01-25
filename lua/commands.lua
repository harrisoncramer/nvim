local async_ok, async = pcall(require, "plenary.async")
local u = require("functions.utils")

vim.api.nvim_create_user_command('SCREENSHOT', function(opts)
  require("functions").screenshot()
end, { nargs = 0 })

vim.api.nvim_create_user_command("RL", function(opts)
  require("functions").reload(opts.args)
end, { nargs = "*" })

vim.api.nvim_create_user_command("RLC", function()
  require("functions").reload_current()
end, { nargs = 0 })

vim.api.nvim_create_user_command("SC", function()
  require("functions").shortcut()
end, { nargs = 0 })

vim.api.nvim_create_user_command("EXEC", function()
  vim.api.nvim_command("silent ! chmod +x %:p")
end, { nargs = 0 })

vim.api.nvim_create_user_command("Stash", function(opts)
  local name = opts.args ~= "" and opts.args or u.get_date_time()
  name = string.gsub(name, "%s+", "_")
  require("functions").stash(name)
  require("notify")(string.format("Stashed %s", name))
end, { nargs = "?" })

vim.api.nvim_create_user_command("SQL", function(opts)
  local db = opts.args
  local var_table = require("env." .. db)
  require("psql").setup(var_table)
  require("notify")("PSQL set to " .. db)
end, { nargs = 1 })

vim.api.nvim_create_user_command("JQ", function()
  vim.api.nvim_command(".!jq .")
end, { nargs = 0 })

vim.api.nvim_create_user_command("Filesystem", function()
  require("functions").run_script("open_filesystem")
end, { nargs = 0 })

vim.api.nvim_create_user_command("BufOnly", function()
  require("functions").buf_only()
end, { nargs = 0 })

vim.api.nvim_create_user_command("Diff", function(opts)
  local branch = opts.args ~= "" and opts.args or "develop"
  vim.api.nvim_feedkeys(":Gvdiffsplit " .. branch .. ":%", "n", false)
  u.press_enter()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>L<C-w>h", false, true, true), "n", false)
  vim.api.nvim_feedkeys("sh", "n", false)
end, { nargs = "*" })

vim.api.nvim_create_user_command('Redir', function(ctx)
  local lines = vim.split(vim.api.nvim_exec(ctx.args, true), '\n', { plain = true })
  vim.cmd('new')
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.opt_local.modified = false
end, { nargs = '+', complete = 'command' })


vim.cmd([[
  command -nargs=? -bar ReviewChanges call setqflist(map(systemlist("git diff --name-only <args>"), '{"filename": v:val, "lnum": 1}'))
]])

-- Load quickfix lists! They can be saved with :w to .qf directory, which is globally gitignored
vim.cmd([[
  if exists('g:loaded_hqf')
      finish
  endif
  let g:loaded_hqf = 1

  function! s:load_file(type, bang, file) abort
      let l:efm = &l:efm
      let &l:errorformat = "%-G%f:%l: All of '%#%.depend'%.%#,%f%.%l col %c%. %m"
      let l:cmd = a:bang ? 'getfile' : 'file'
      exec a:type.l:cmd.' '.a:file
      let &l:efm = l:efm
      execute 'copen'
  endfunction

  command! -complete=file -nargs=1 -bang Qfl call <SID>load_file('c', <bang>0, <f-args>)
]])

vim.cmd([[
function! TabMessage(cmd)
  redir => message
  silent execute a:cmd
  redir END
  if empty(message)
    echoerr "no output"
  else
    " use "new" instead of "tabnew" below if you prefer split windows instead of tabs
    tabnew
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
    silent put=message
  endif
endfunction
command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)
]])

-- Pandoc
vim.api.nvim_create_user_command("PDF", function()
  local filename = u.copy_file_name(true)
  local no_extension = u.strip_extension(filename)
  local pdf = no_extension .. ".pdf"
  if u.file_exists(pdf) then
    u.remove_file(pdf)
  end

  local plenary_ok, job = pcall(require, "plenary.job")
  if not plenary_ok then
    require("notify")("Could not load Plenary.", vim.log.levels.ERROR)
    return
  end

  job:new({
    command = 'pandoc',
    args = { '-V', 'colorlinks=true', '-V', 'linkcolor=blue', '-i', filename, "-o", pdf },
    on_exit = vim.schedule_wrap(function(err, exit_code)
      if exit_code ~= 0 then
        vim.print(_)
        require("notify")("Could not create " .. pdf .. "\n " .. err._stderr_results[1], vim.log.levels.ERROR)
        return
      else
        vim.notify(pdf .. " created!", vim.log.levels.INFO)
        vim.cmd("silent !open " .. pdf)
      end
    end),
  }):start()
end, {
  nargs = 0,
})

vim.api.nvim_create_user_command('WRAP', function(opts)
  if vim.wo.wrap then
    vim.cmd("set nowrap")
    vim.cmd("set nolinebreak")
  else
    vim.cmd("set wrap")
    vim.cmd("set linebreak")
  end
end, { nargs = 0 })
