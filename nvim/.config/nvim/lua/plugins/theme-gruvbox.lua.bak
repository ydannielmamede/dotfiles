return {
  "ellisonleao/gruvbox.nvim",
  priority = 1000,
  config = function()
    -- local is_light = vim.o.background == "light"

    require("gruvbox").setup({
      terminal_colors = true,
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true,
      contrast = "hard",
      palette_overrides = {},
      overrides = {
        Comment = { fg = is_light and "#7c6f64" or "#928374", italic = true },

        -- Variáveis em azul
        ["@variable"] = { link = "GruvboxBlue" },
        ["@variable.builtin"] = { link = "GruvboxBlue" },
        ["@variable.member"] = { link = "GruvboxBlue" },
        ["@variable.parameter"] = { link = "GruvboxBlue" },
        ["@variable.field"] = { link = "GruvboxBlue" },

        -- Módulos em laranja
        ["@module"] = { link = "GruvboxOrange" },
        ["@module.builtin"] = { link = "GruvboxOrange" },
        ["@module.import"] = { link = "GruvboxOrange" }, -- Comum em várias linguagens
        -- Classes e Tipos em Aqua
        ["@type"] = { link = "GruvboxAqua" },
        ["@type.definition"] = { link = "GruvboxAqua" },
        ["@type.builtin"] = { link = "GruvboxAqua" },
        ["@class"] = { link = "GruvboxAqua" },
        ["@constructor"] = { link = "GruvboxAqua" },

        -- Constantes Roxas e String Verdes
        ["@constant"] = { link = "GruvboxPurple" },
        ["@constant.builtin"] = { link = "GruvboxPurple" },
        ["@string"] = { link = "GruvboxGreen" },

        -- Funções em amarelo
        ["@function"] = { link = "GruvboxYellow" },
        ["@function.builtin"] = { link = "GruvboxYellow" },
        ["@function.call"] = { link = "GruvboxYellow" },
        ["@function.method"] = { link = "GruvboxYellow" },
        ["@function.method.call"] = { link = "GruvboxYellow" },
        -- Destaque do Illuminate (Branco)
        IlluminatedWordRead = { fg = "#ebdbb2", bg = "#504945" }, -- GruvboxFg1 com fundo sutil
        IlluminatedWordWrite = { fg = "#ebdbb2", bg = "#504945" },
      },
      m_inactive = false,
      transparent_mode = true,
    })
    vim.cmd("colorscheme gruvbox")
  end,
}
