local M = {}

-- This handler will jump to the definition of a LSP item if
-- it's already open in a buffer rather than replacing the current buffer
-- with the new buffer
local function smart_jump_to_definition()
  local log = require('vim.lsp.log')

  -- Handler that looks for existing buffer and window before jumping
  local handler = function(_, result, ctx)
    local refined_result = result[1] == nil and result or result[1]
    if refined_result == nil or vim.tbl_isempty(refined_result) then
      log.info("No definition found")
      return
    end

    local uri = refined_result.uri or refined_result.targetUri
    if not uri then
      log.info("No URI found in definition result")
      return
    end

    local range = refined_result.range or refined_result.targetRange
    if range == nil then
      log.info("No range found in definition result")
      return
    end

    local bufnr = vim.uri_to_bufnr(uri)
    local windows = vim.fn.win_findbuf(bufnr)

    -- If buffer is already open in a window, jump to that window
    if #windows > 0 then
      vim.api.nvim_set_current_win(windows[1])
      vim.api.nvim_win_set_cursor(windows[1],
        { range.start.line + 1, range.start.character })
    else
      vim.lsp.buf.definition() -- If buffer is not open in any window, open it in the current window
    end
  end

  -- Set up the custom handler for 'textDocument/definition'
  vim.lsp.buf_request(0, 'textDocument/definition', vim.lsp.util.make_position_params(), handler)
end

M.smart_jump_to_definition = smart_jump_to_definition

return M
