return {
	"seblyng/roslyn.nvim",
	---@module 'roslyn.config'
	---@type RoslynNvimConfig
	opts = {
		-- Para lspconfig, no setup do roslyn ou csharp_ls:
		vim.api.nvim_create_autocmd("VimLeavePre", {
			callback = function()
				vim.lsp.stop_client(vim.lsp.get_clients())
			end,
		}),
		-- your configuration comes here; leave empty for default settings
	},
}
