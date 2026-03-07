require("config.lazy")
require("config.lsp")
require("config.options")
require("config.diagnostics")
--usar clipboard do sistema operacional
vim.opt.clipboard = "unnamedplus"

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

