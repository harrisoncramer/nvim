return {
	setup = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		local dino = {
			"                                                ",
			"            ,                                   ",
			"           /|                                    ",
			"          / |                                   ",
			"         /  /                                   ",
			"        |   |                                   ",
			"       |      \\__                               ",
			"       \\       __\\_______                       ",
			"        \\                 \\_                    ",
			"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
			"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
			"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
			"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
			"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
			"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
			"         /\\    \\_               \\               ",
			"        / |      \\__ (   )       \\              ",
			"       /  \\      / |\\\\  /       __\\____         ",
			"       |  ,     |  /\\ \\ \\__    |       \\_       ",
			"       \\_/|\\___/   \\   \\}}}\\__|  (@)     )      ",
			"        \\)\\)\\)      \\_\\---\\   \\|       \\ \\      ",
			"                      \\>\\>\\>   \\   /\\__o_o)     ",
			"                                | /  VVVVV      ",
			"                                \\ \\    \\        ",
			"                                 \\ \\MMMMM       ",
			"                                  \\______/      ",
		}

		local cow = {
			"                 /                       \\                          ",
			"               /X/                      \\X\\                          ",
			"              |XX\\         _____         /XX|                          ",
			"              |XXX\\     _/       \\_     /XXX|___________                          ",
			"               \\XXXXXXX             XXXXXXX/            \\\\                          ",
			"                 \\XXXX    /     \\    XXXXX/                \\\\                          ",
			"                      |   0     0   |                         \\                          ",
			"                       |           |                           \\                          ",
			"                        \\         /                            |______//                          ",
			"                         \\       /                             |                          ",
			"                          | O_O | \\                            |                          ",
			"                           \\ _ /   \\________________           |                          ",
			"                                      | |  | |      \\         /                          ",
			"                Neovim!               / |  | |       \\______/                          ",
			"                                      | |  | |        | | | |                          ",
			"                                    __| |__| |      __| |_| |                          ",
			"                                   |___||___//     |__||___ |                          ",
		}

		dashboard.section.header.val = dino

		-- Set menu
		dashboard.section.buttons.val = {
			dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button("f", "  > Find file", ":Telescope find_files<CR>"),
			dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
			dashboard.button("v", "  > Neovim", ":e $MYVIMRC | :cd %:p:h<CR>"),
			dashboard.button("z", "  > Zsh", ":e ~/.zshrc | :cd %:p:h<CR>"),
			dashboard.button("q", "  > Quit NVIM", ":qa<CR>"),
		}

		-- Send config to alpha
		alpha.setup(dashboard.opts)

		-- Disable folding on alpha buffer
		vim.cmd([[ autocmd FileType alpha setlocal nofoldenable ]])
	end,
}
