local M = {}

M.get_current_service = function()
  return vim.fs.basename(vim.fn.getcwd())
end

M.get_build_failures = function()
  local svc = M.get_current_service()
  local failures = vim.fn.systemlist(string.format("failures %s", svc))

  local qf_list = {}

  for _, line in ipairs(failures) do
    local file, lnum, col, message = line:match("(.-):(%d+):(%d+): (.+)")
    if file and lnum and col and message then
      table.insert(qf_list, {
        filename = file,
        lnum = tonumber(lnum),
        col = tonumber(col),
        text = message,
      })
    end
  end

  if #qf_list > 0 then
    vim.fn.setqflist(qf_list, "r")
    vim.cmd("copen") -- Open quickfix list
  else
    vim.notify("No failures found", vim.log.levels.INFO)
  end
end

return M
