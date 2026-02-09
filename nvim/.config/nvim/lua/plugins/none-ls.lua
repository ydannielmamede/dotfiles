return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.prettier, -- JS, TS, HTML, CSS
				null_ls.builtins.formatting.black, -- Python
				-- null_ls.builtins.formatting.clang_format, -- C/C++
				null_ls.builtins.formatting.gofmt, -- Go
				null_ls.builtins.formatting.stylua, -- Lua
				null_ls.builtins.formatting.google_java_format, -- Java
			},
		})

		-- Formatar código
		vim.keymap.set("n", "<leader>qq", function()
			vim.lsp.buf.format({ async = true })
		end, { desc = "Format code" })

		-- Comando global para organizar imports (Java, TS, etc.)
		vim.api.nvim_create_user_command("OrganizeImports", function()
			vim.lsp.buf.code_action({
				context = { only = { "source.organizeImports" } },
				apply = true,
			})
		end, { desc = "Organize imports" })

		-- Atalho global
		vim.keymap.set(
			"n",
			"<leader>oi",
			"<cmd>OrganizeImports<CR>",
			{ noremap = true, silent = true, desc = "Organize imports" }
		)
	end,
}
