-- Terminal dedicado para serial monitor Arduino ---------------------------------
--
-- Abre um terminal toggleterm pré-configurado com `arduino-cli monitor`.
-- Use :ArduinoMonitor (leader+am) — definido em arduino-cli.lua.

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<C-\\>", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
    },
    opts = {
      direction = "horizontal",
      size = 10,
      open_mapping = [[<C-\>]],
      persist_size = true,
      persist_mode = true,
    },
  },
}
