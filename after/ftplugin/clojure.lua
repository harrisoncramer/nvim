local job = require("plenary.job")

local format_file = function()
	vim.cmd("w")
	local file = vim.fn.expand("%")
	job:new({
		command = "zprint",
		args = { "-w", file },
		on_exit = vim.schedule_wrap(function(_, exit_code)
			vim.cmd("e")
			if exit_code ~= 0 then
				require("notify")("Could not format file!", "error")
				return
			end
		end),
	}):start()
end

vim.keymap.set(
	"n",
	"<localleader>cc",
	":ConjureConnect<CR>",
	{ unpack(local_keymap_opts), desc = "Connect to Conjure" }
)
vim.keymap.set("n", "ZZ", format_file, merge(local_keymap_opts, { desc = "Format Clojure file" }))
