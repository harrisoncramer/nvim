local M = {}

M.get = function()
	local function_query = vim.treesitter.query.parse(
		"go",
		[[
    (function_declaration
      name: (identifier) @func_name
      parameters: (parameter_list)?
      body: (block) @func_body)
  ]]
	)
	local method_query = vim.treesitter.query.parse(
		"go",
		[[
    (method_declaration
      receiver: (parameter_list) @receiver
      name: (field_identifier) @method_name
      body: (block)? @method_body)
  ]]
	)
	return {
		function_query = function_query,
		method_query = method_query,
	}
end

return M
