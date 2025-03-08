_G.global_keymap_opts = { noremap = true, silent = true, nowait = true }
_G.local_keymap_opts = { noremap = true, silent = true, nowait = true, buffer = 0 }

_G.merge = function(...)
	local result = {}
	local sources = { ... }
	for i = 1, #sources do
		local source = sources[i]
		for key, value in pairs(source) do
			result[key] = value
		end
	end
	return result
end
