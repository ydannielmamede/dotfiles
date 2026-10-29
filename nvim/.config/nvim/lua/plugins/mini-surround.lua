return {
  "echasnovski/mini.surround",
  version = false,
  event = "VeryLazy",
  opts = {
    -- Inverte o padrão do mini.surround para parênteses.
    custom_surroundings = {
      ["("] = { output = { left = "(", right = ")" } },
      [")"] = { output = { left = "( ", right = " )" } },
    },
    mappings = {
      add = "sa",
      delete = "sd",
      replace = "sr",
      find = "sf",
      find_left = "sF",
      highlight = "sh",
      update_n_lines = "sn",
    },
  },
  config = function(_, opts)
    require("mini.surround").setup(opts)

    vim.keymap.set("x", "s", [[:<C-u>lua MiniSurround.add("visual")<CR>]], {
      silent = true,
      desc = "Envolver seleção",
    })
  end,
}
