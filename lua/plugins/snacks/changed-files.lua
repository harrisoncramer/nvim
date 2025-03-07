local git_helpers = require("../../git-helpers")

local ChangedFiles = {}
ChangedFiles.__index = ChangedFiles

function ChangedFiles.new(branch)
	local files = {}
	setmetatable(files, ChangedFiles)
	files.all_files = {}
	files.branch = branch
	return files
end

function ChangedFiles:formatted()
	local t = {}
	for _, v in ipairs(self:get_all()) do
		table.insert(t, {
			title = v.filename,
			text = v.filename,
			file = v.filename,
		})
	end
	return t
end

function ChangedFiles:get_all()
	self.all_files = git_helpers.changed_files(self.branch)
	return self.all_files
end

return ChangedFiles
