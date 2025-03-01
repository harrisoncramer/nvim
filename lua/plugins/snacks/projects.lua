local Projects = {}
Projects.__index = Projects

function Projects.new()
	local projects = {}
	setmetatable(projects, Projects)
	projects.all_projects = {
		"~/chariot/chariot",
		"~/chariot/proto",
		"~/chariot/ops",
		"~/chariot/deploy",
		"~/.dotfiles",
		"~/.config/nvim",
	}
	return projects
end

function Projects:formatted_projects()
	local t = {}
	for _, v in ipairs(self:get_all_projects()) do
		table.insert(t, {
			title = v,
			text = v,
			file = v,
		})
	end
	return t
end

function Projects:get_all_projects()
	return self.all_projects
end

function Projects:find_project_by_bufnr(bufnr)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	for i = #self.all_projects, 1, -1 do
		local project = self.all_projects[i]
		if filepath:find(vim.fn.expand(project), 1, true) then
			return project
		end
	end
	return nil
end

return Projects
