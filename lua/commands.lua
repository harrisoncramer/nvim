local u = require("functions.utils")
vim.api.nvim_create_user_command("RL", function(opts)
	require("functions").reload(opts.args)
end, { nargs = "*" })

vim.api.nvim_create_user_command("RLC", function()
	require("functions").reload_current()
end, { nargs = 0 })

vim.api.nvim_create_user_command("SC", function()
	require("functions").shortcut()
end, { nargs = 0 })

vim.api.nvim_create_user_command("CAL", function()
	require("functions").calendar()
end, { nargs = 0 })

vim.api.nvim_create_user_command("Stash", function(opts)
	local name = opts.args ~= "" and opts.args or u.get_date_time()
	name = string.gsub(name, "%s+", "_")
	require("functions").stash(name)
	print(string.format("Stashed %s", name))
end, { nargs = "?" })

vim.api.nvim_create_user_command("SQL", function(opts)
	local db = opts.args
	local var_table = require("env." .. db)
	require("psql").setup(var_table)
	print("PSQL set to " .. db)
end, { nargs = 1 })

vim.api.nvim_create_user_command("JQ", function()
	vim.api.nvim_command(".!jq .")
end, { nargs = 0 })

vim.api.nvim_create_user_command("Filesystem", function()
	require("functions").run_script("open_filesystem")
end, { nargs = 0 })

local is_sharing = false
vim.api.nvim_create_user_command("Share", function()
	require("functions").share_screen(is_sharing)
	is_sharing = not is_sharing
end, { nargs = 0 })

vim.api.nvim_create_user_command("Diff", function(opts)
	local branch = opts.args ~= "" and opts.args or "develop"
	vim.api.nvim_feedkeys(":Gvdiffsplit " .. branch .. ":%", "n", false)
	u.press_enter()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>L<C-w>h", false, true, true), "n", false)
end, { nargs = "*" })

-- Load quickfix lists! They can be saved with :w to .qf folder, which is globally gitignored
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
