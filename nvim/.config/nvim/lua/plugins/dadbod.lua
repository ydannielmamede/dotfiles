return {
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
		keys = {
			{ "<leader>m", "<cmd>DBUIToggle<CR>", desc = "Toggle DBUI" },
		},
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_show_database_navigation = 1
		end,
	},
	{
		"saghen/blink.cmp",
		opts = {
			sources = {
				per_filetype = {
					sql = { "lsp", "snippets", "dadbod", "buffer" },
					mysql = { "lsp", "snippets", "dadbod", "buffer" },
					plsql = { "lsp", "snippets", "dadbod", "buffer" },
				},
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
