vim.opt.number = true
-- vim.opt.relativenumber = true

-- Abrir links com o visualizador disponível no sistema.
vim.g.netrw_browsex_viewer = vim.fn.has("win32") == 1 and "start" or "xdg-open"

-- Selcionar tudo com Ctrl+A
vim.keymap.set("n", "<C-a>", "ggVG", { noremap = true, silent = true })

-- Salvar no Ctrl+S
vim.keymap.set("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })
-- Ctrl+X = salvar e sair
vim.keymap.set("n", "<C-x>", ":wq<CR>", { noremap = true, silent = true })
-- Ctrl+Q = sair
vim.keymap.set("n", "<C-q>", ":q<CR>", { noremap = true, silent = true })

-- Movimentação entre splits
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-j>", "<C-w>j")

-- Mover linhas como no VS Code com Alt + j/k
vim.keymap.set("n", "<A-k>", "<cmd>move .-2<CR>==", { desc = "Mover linha para cima" })
vim.keymap.set("n", "<A-j>", "<cmd>move .+1<CR>==", { desc = "Mover linha para baixo" })
vim.keymap.set("v", "<A-k>", ":move '<-2<CR>gv=gv", { desc = "Mover seleção para cima" })
vim.keymap.set("v", "<A-j>", ":move '>+1<CR>gv=gv", { desc = "Mover seleção para baixo" })
vim.keymap.set("i", "<A-k>", "<Esc><cmd>move .-2<CR>==gi", { desc = "Mover linha para cima" })
vim.keymap.set("i", "<A-j>", "<Esc><cmd>move .+1<CR>==gi", { desc = "Mover linha para baixo" })

-- Live Server ON
vim.keymap.set("n", "<leader>ls", ":LiveServerStart<CR>", { desc = "Live Server Start" })
-- Live Server OFF
vim.keymap.set("n", "<leader>lk", ":LiveServerStop<CR>", { desc = "Live Server Stop" })

-- vim.api.nvim_set_hl(0, "LineNr", {
--   fg = "#A6E3A2", -- cor do número
--   bg = "NONE"
-- })

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

--renomear rapido
vim.keymap.set("n", "<leader>R", vim.lsp.buf.rename, { desc = "Rename symbol" })

--atalho para Wrap with Abbreviation do plugin Emmet
vim.keymap.set("v", "<leader>w", "<C-y>,", { remap = true, desc = "Emmet Wrap" })

--tirar barra embaixo
vim.o.laststatus = 3
vim.o.showmode = false
vim.o.cmdheight = 0

--go to definition
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Ir para a definição' })
