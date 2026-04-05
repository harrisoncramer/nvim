local M = {}

-- Checks if port is available
function M.is_port_available(port)
	local handle = io.popen("nc -z localhost " .. port .. " 2>/dev/null; echo $?")
	if not handle then
		return false
	end
	local result = handle:read("*a")
	handle:close()
	return result:match("^0") ~= nil
end

return M
