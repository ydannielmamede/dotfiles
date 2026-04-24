return {
	"tpope/vim-fugitive",
	cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse", "Gedit" },
	keys = {
		{ "<leader>gs", "<cmd>Git<cr>", desc = "Git status" },
		{ "<leader>gc", "<cmd>Git commit<cr>", desc = "Git commit" },
		{ "<leader>gp", "<cmd>Git push<cr>", desc = "Git push" },
		{ "<leader>gl", "<cmd>Git pull<cr>", desc = "Git pull" },
		{ "<leader>gd", "<cmd>Gdiffsplit<cr>", desc = "Git diff" },
		{ "<leader>gb", "<cmd>Git blame<cr>", desc = "Git blame" },
		{ "<leader>gB", "<cmd>GBrowse<cr>", desc = "Git browse" },
		{ "<leader>gr", "<cmd>Gread<cr>", desc = "Git checkout buffer" },
		{ "<leader>gw", "<cmd>Gwrite<cr>", desc = "Git add buffer" },
		{ "<leader>gL", "<cmd>Git log<cr>", desc = "Git log" },
	},
}
