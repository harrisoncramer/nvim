-- Provides the ability to run executables from within Neovim!
return {
	run_script = function(script_name)
		local nvim_scripts_dir = "~/.config/nvim/scripts"
		local proc = io.popen(string.format("/bin/bash %1s/%2s", nvim_scripts_dir, script_name))
		local l = proc:read("*a")
		proc:close()
		print(l)
		return l
	end,
}
