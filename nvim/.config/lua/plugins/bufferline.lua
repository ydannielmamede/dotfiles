return {
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons", -- ícones dos arquivos
		opts = {
			options = {
				numbers = "none", -- "ordinal" | "buffer_id" | "none"
				close_command = "bdelete! %d", -- comando para fechar buffer
				right_mouse_command = "bdelete! %d",
				left_trunc_marker = "",
				right_trunc_marker = "",
				max_name_length = 30,
				max_prefix_length = 15, -- para nomes duplicados
				tab_size = 21,
				show_buffer_close_icons = true,
				show_close_icon = true,
				enforce_regular_tabs = false,
				view = "multiwindow",
				show_tab_indicators = true,
				persist_buffer_sort = true,
				separator_style = "thin", -- "slant" | "thick" | "thin"
				diagnostics = "nvim_lsp", -- mostra erros e avisos do LSP
				always_show_bufferline = true,
				offsets = {
					{
						filetype = "NvimTree",
						text = "Explorer",
						highlight = "Directory",
						text_align = "left",
					},
				},
			},
			highlights = {
				fill = {
					guifg = { attribute = "fg", highlight = "Normal" },
					guibg = { attribute = "bg", highlight = "StatusLineNC" },
				},
				background = {
					guifg = { attribute = "fg", highlight = "Normal" },
					guibg = { attribute = "bg", highlight = "StatusLine" },
				},
				buffer_selected = {
					guifg = { attribute = "fg", highlight = "Normal" },
					guibg = { attribute = "bg", highlight = "Normal" },
					gui = "bold",
				},
			},
		},
		-- Função config para mapeamentos de Alt+numero
		config = function(_, opts)
			local bufferline = require("bufferline")
			bufferline.setup(opts)

			-- Alt + 1..9 para ir para o buffer correspondente
			for i = 1, 9 do
				vim.api.nvim_set_keymap(
					"n",
					"<A-" .. i .. ">",
					":BufferLineGoToBuffer " .. i .. "<CR>",
					{ noremap = true, silent = true }
				)
			end

			-- Alt + 0 para ir para o último buffer
			vim.api.nvim_set_keymap("n", "<A-0>", ":BufferLineGoToBuffer -1<CR>",
				{ noremap = true, silent = true })

			-- Alt + q → fechar buffer atual
			vim.keymap.set("n", "<A-q>", "<Cmd>bdelete<CR>", { silent = true })
		end,
	},
}
