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
		require("bqf").setup({})
	end,
}
