local function toggleQf()
	local ft = vim.bo.filetype
	if ft == "qf" then
		vim.cmd("cclose")
	else
		vim.cmd("copen")
	end
end

return {
	toggleQf = toggleQf,
	setup = function()
		require("compat").remap("n", "<leader>q", toggleQf, {}, ":lua require('plugins/bqf').toggleQf()<CR>")
		require("bqf").setup({
			func_map = {
				cool = function()
					print("wow")
				end,
			},
			preview = {
				border_chars = { "│", "│", "─", "─", "╭", "╮", "╰", "╯", "│" },
			},
			filter = {
				fzf = {
					action_for = {
						["enter"] = "signtoggle",
					},
				},
			},
		})
	end,
}
