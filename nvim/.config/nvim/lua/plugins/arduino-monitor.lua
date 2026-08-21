-- Terminal dedicado para serial monitor Arduino ---------------------------------
--
-- Abre um terminal toggleterm pré-configurado com `arduino-cli monitor`.
-- Use :ArduinoMonitor (leader+am) — definido em arduino-cli.lua.

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        direction = "horizontal",   -- terminal na parte de baixo
        size = 10,                  -- altura em linhas
        open_mapping = [[<C-\>]],   -- atalho Ctrl+\
        -- Persiste terminais ao trocar de buffer
        persist_size = true,
        persist_mode = true,
      })
    end,
  },
}
