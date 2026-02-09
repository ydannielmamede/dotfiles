require("config.lazy")
require("config.lsp")
require("config.options")

vim.opt.termguicolors = true
require("bufferline").setup{}

--notificacoes
-- require("notify").setup({
--   background_colour = "#000000",
-- })

-- abrir diretorio na pasta atual
vim.opt.autochdir = true

--snippets vs-code
require("luasnip.loaders.from_vscode").lazy_load()

