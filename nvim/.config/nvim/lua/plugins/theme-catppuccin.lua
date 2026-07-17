return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "auto",
        background = {
          light = "latte",
          dark = "mocha",
        },
        transparent_background = true,
        float = {
          transparent = true,
          solid = false,
        },
        show_end_of_buffer = false,
        term_colors = true,
        dim_inactive = {
          enabled = false,
          shade = "dark",
          percentage = 0.15,
        },
        no_italic = false,
        no_bold = false,
        no_underline = false,
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
        },
        lsp_styles = {
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
            ok = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
            ok = { "underline" },
          },
          inlay_hints = {
            background = true,
          },
        },
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          mini = {
            enabled = true,
            indentscope_color = "",
          },
        },
        custom_highlights = function(colors)
          return {
            Comment = { fg = colors.overlay1, style = { "italic" } },

            -- Variáveis em azul
            ["@variable"] = { fg = colors.blue },
            ["@variable.builtin"] = { fg = colors.blue },
            ["@variable.member"] = { fg = colors.blue },
            ["@variable.parameter"] = { fg = colors.blue },
            ["@variable.field"] = { fg = colors.blue },

            -- Módulos em laranja
            ["@module"] = { fg = colors.peach },
            ["@module.builtin"] = { fg = colors.peach },
            ["@module.import"] = { fg = colors.peach },

            -- Classes e Tipos em aqua
            ["@type"] = { fg = colors.teal },
            ["@type.definition"] = { fg = colors.teal },
            ["@type.builtin"] = { fg = colors.teal },
            ["@class"] = { fg = colors.teal },
            ["@constructor"] = { fg = colors.teal },

            -- Constantes roxas e strings verdes
            ["@constant"] = { fg = colors.mauve },
            ["@constant.builtin"] = { fg = colors.mauve },
            ["@string"] = { fg = colors.green },

            -- Funções em amarelo
            ["@function"] = { fg = colors.yellow },
            ["@function.builtin"] = { fg = colors.yellow },
            ["@function.call"] = { fg = colors.yellow },
            ["@function.method"] = { fg = colors.yellow },
            ["@function.method.call"] = { fg = colors.yellow },

            -- Destaque do Illuminate
            IlluminatedWordRead = { fg = colors.text, bg = colors.surface1 },
            IlluminatedWordWrite = { fg = colors.text, bg = colors.surface1 },
          }
        end,
      })

      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
