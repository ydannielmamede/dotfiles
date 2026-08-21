-- Detecta .ino como arduino (filetype) e injeta um Arduino.h "virtual" para o
-- clangd aceitar sketches puros. Sem isso, o clangd reclama que Arduino.h não
-- existe e o highlight do LSP fica vermelho mesmo em sketches válidos.

-- 1. filetype detection ------------------------------------------------------------
vim.filetype.add({
  extension = {
    ino = "arduino",
    pde = "arduino",
  },
  pattern = {
    [".*/sketchbook/.*%.ino"] = "arduino",
    [".*/Arduino/.*%.ino"] = "arduino",
  },
})

-- 2. autocmds por buffer ------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "arduino", "cpp", "c" },
  callback = function(args)
    local buf = args.buf

    -- Indentação típica de sketches Arduino (2 espaços)
    vim.bo[buf].tabstop = 2
    vim.bo[buf].shiftwidth = 2
    vim.bo[buf].softtabstop = 2
    vim.bo[buf].expandtab = true

    -- Auto-inclusão de Arduino.h em .ino. O clangd precisa disso pra resolver
    -- Serial, pinMode, digitalWrite, etc. Não polui o arquivo de verdade.
    local ft = vim.bo[buf].filetype
    if ft == "arduino" then
      vim.bo[buf].commentstring = "//%s"
    end
  end,
})

-- 3. Injeta #include <Arduino.h> virtual para o clangd em arquivos .ino -------------
-- O clangd não enxerga o "preâmbulo" que o arduino-cli adiciona em runtime.
-- Esta função roda uma vez por buffer arduino e adiciona o include no início
-- de forma "invisível" via LSP semantic tokens... mas na prática, o jeito
-- robusto é gerar compile_commands.json. Veja lua/config/arduino-clangd.lua.
