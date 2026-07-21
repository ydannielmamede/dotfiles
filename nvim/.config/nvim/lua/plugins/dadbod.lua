return {
	-- Configuração do Dadbod UI
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		},
		cmd = {

			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		init = function()
			-- Configurações da interface
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_show_database_navigation = 1

			-- Atalho para abrir a interface
			vim.keymap.set("n", "<leader>m", ":DBUIToggle<CR>", { desc = "Toggle DBUI" })
		end,

		-- O 'config' antigo com autocmd para nvim-cmp foi removido
		-- pois o blink.cmp cuida disso agora.
	},
	-- Configuração do Blink.cmp
	{

		"saghen/blink.cmp",
		opts = {
			sources = {
				-- Fontes padrão para todos os arquivos
				default = { "lsp", "path", "snippets", "buffer" },
				-- Configuração específica para SQL
				per_filetype = {
					sql = { "lsp","snippets", "dadbod", "buffer" },
					mysql = {"lsp", "snippets", "dadbod", "buffer" },
					plsql = {"lsp", "snippets", "dadbod", "buffer" },
				},
				-- Registrando o provedor do Dadbod
				providers = {
					dadbod = {
						name = "Dadbod",
						module = "vim_dadbod_completion.blink",
					},
				},
			},
		},
	},
}
