return {
	{
		"projekt0n/github-nvim-theme",
		name = "github-theme",
		lazy = false,
		priority = 1000,
		config = function()
			-- Detecta o tema do sistema (GNOME)
			local function get_system_theme()
				local handle = io.popen("gsettings get org.gnome.desktop.interface color-scheme")
				if not handle then
					return "dark"
				end
				local result = handle:read("*a")
				handle:close()
				return result:match("dark") and "dark" or "light"
			end

			-- Aplica o tema correto
			local function apply_theme()
				local is_dark = get_system_theme() == "dark"

				require("github-theme").setup({
					options = {
						transparent = is_dark, -- transparente só no modo escuro
					},
				})

				if is_dark then
					vim.cmd("colorscheme github_dark_dimmed")
				else
					vim.cmd("colorscheme github_light")
				end
			end

			-- Aplica ao iniciar
			apply_theme()

			-- Atualiza automaticamente quando o sistema muda
			local last = nil
			local timer = vim.loop.new_timer()
			timer:start(
				0,
				5000,
				vim.schedule_wrap(function()
					local current = get_system_theme()
					if current ~= last then
						apply_theme()
						last = current
					end
				end)
			)
		end,
	},
}
