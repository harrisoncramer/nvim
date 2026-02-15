local M = {}

function M.get_repo_root()
	local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
	if not handle then
		return nil
	end
	local result = handle:read("*a")
	handle:close()
	return result:gsub("%s+$", "")
end

function M.get_port_offset()
	local repo_root = M.get_repo_root()
	if not repo_root then
		return 0
	end

	local env_ports_path = repo_root .. "/.env.ports"
	local file = io.open(env_ports_path, "r")
	if not file then
		return 0
	end

	for line in file:lines() do
		local offset = line:match("^# Offset:%s*(%d+)")
		if offset then
			file:close()
			return tonumber(offset)
		end
	end

	file:close()
	return 0
end

function M.get_service_ports()
	local repo_root = M.get_repo_root()
	if not repo_root then
		return {}
	end

	local port_offset = M.get_port_offset()
	local services = {}

	local handle = io.popen('find "' .. repo_root .. '/apps" -name ".air.toml" -type f 2>/dev/null')
	if not handle then
		return {}
	end

	for air_file in handle:lines() do
		local service_name = air_file:match("/apps/([^/]+)/%.air%.toml$")
		if service_name then
			local file = io.open(air_file, "r")
			if file then
				local content = file:read("*a")
				file:close()

				local base_port = content:match("listen%s+:(%d+)")
				if base_port then
					local actual_port = tonumber(base_port) + port_offset
					services[service_name] = actual_port
				end
			end
		end
	end

	handle:close()
	return services
end

function M.check_port_available(port)
	local handle = io.popen("nc -z localhost " .. port .. " 2>/dev/null; echo $?")
	if not handle then
		return false
	end
	local result = handle:read("*a")
	handle:close()
	return result:match("^0") ~= nil
end

function M.attach_to_service(dap, dapui)
	local services = M.get_service_ports()
	local repo_root = M.get_repo_root()

	if vim.tbl_isempty(services) then
		vim.notify("No services found with debug ports configured", vim.log.levels.ERROR)
		return
	end

	local service_list = {}
	for service, port in pairs(services) do
		table.insert(service_list, service .. " (localhost:" .. port .. ")")
	end
	table.sort(service_list)

	vim.ui.select(service_list, {
		prompt = "Select a service to debug:",
	}, function(choice)
		if not choice then
			return
		end

		local service_name = choice:match("^([^%s]+)")
		local port = services[service_name]

		if not M.check_port_available(port) then
			vim.notify("Service " .. service_name .. " not running on localhost:" .. port, vim.log.levels.ERROR)
			return
		end

		dap.run({
			type = "go",
			name = "Attach to " .. service_name,
			mode = "remote",
			request = "attach",
			host = "127.0.0.1",
			port = port,
			substitutePath = {
				{
					from = repo_root .. "/apps",
					to = "/apps",
				},
			},
		})

		vim.notify("Attaching to " .. service_name .. " on port " .. port, vim.log.levels.INFO)
	end)
end

return M
