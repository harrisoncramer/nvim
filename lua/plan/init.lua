vim.api.nvim_create_user_command("Plan", function()
	vim.ui.input({ prompt = "Plan Name:" }, function(input)
		if not input or input == "" then
			return
		end
		local task_name = input:gsub(" ", "-"):lower()
		local timestamp = os.date("%Y%m%d")
		local filename = string.format(".plans/%s-%s.md", timestamp, task_name)

		local template = [[
# %s

## Objective

## Research

## Implementation Steps

1. 

## Out of Scope (Avoid)

## Tests and Validation

]]

		vim.cmd("edit " .. filename)
		vim.api.nvim_buf_set_lines(
			0,
			0,
			-1,
			false,
			vim.split(string.format(template, input, os.date("%Y-%m-%d")), "\n")
		)
	end)
end, { nargs = 0 })
