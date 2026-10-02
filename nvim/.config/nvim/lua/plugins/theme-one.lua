return {
  "navarasu/onedark.nvim",
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    require("onedark").setup({
      -- Main options --
      style = "deep",            -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
      transparent = true,       -- Show/hide background
      term_colors = true,        -- Change terminal color as per the selected theme style
      ending_tildes = false,     -- Show the end-of-buffer tildes. By default they are hidden
      cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

      -- toggle theme style ---
      toggle_style_key = "<leader>ts",      -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
      -- "dark", "darker", "cool", "warm", "warmer",
      toggle_style_list = { "deep", "light" }, -- List of styles to toggle between

      -- Change code style ---
      -- Options are italic, bold, underline, none
      -- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
      code_style = {
        comments = "italic,bold",
        keywords = "none",
        functions = "italic",
        strings = "italic",
        variables = "none",
      },

      -- Lualine options --
      lualine = {
        transparent = false, -- lualine center bar transparency
      },

      -- Custom Highlights --
      colors = {},  -- Override default colors
      highlights = {
        Comment = { fg = "$fg", fmt = "italic" },
        ["@comment"] = { fg = "$fg", fmt = "italic" },
        LineNr = { fg = "$fg" },
        LineNrAbove = { fg = "$fg" },
        LineNrBelow = { fg = "$fg" },

        -- Variáveis em azul
        ["@variable"] = { fg = "$blue" },
        ["@variable.builtin"] = { fg = "$blue" },
        ["@variable.member"] = { fg = "$blue" },
        ["@variable.parameter"] = { fg = "$blue" },
        ["@variable.field"] = { fg = "$blue" },

        -- Módulos em laranja
        ["@module"] = { fg = "$orange" },
        ["@module.builtin"] = { fg = "$orange" },
        ["@module.import"] = { fg = "$orange" },

        -- Classes e Tipos em aqua
        ["@type"] = { fg = "$cyan" },
        ["@type.definition"] = { fg = "$cyan" },
        ["@type.builtin"] = { fg = "$cyan" },
        ["@class"] = { fg = "$cyan" },
        ["@constructor"] = { fg = "$cyan" },

        -- Constantes roxas e strings verdes
        ["@constant"] = { fg = "$purple" },
        ["@constant.builtin"] = { fg = "$purple" },
        ["@string"] = { fg = "$green" },

        -- Funções em amarelo
        ["@function"] = { fg = "$yellow" },
        ["@function.builtin"] = { fg = "$yellow" },
        ["@function.call"] = { fg = "$yellow" },
        ["@function.method"] = { fg = "$yellow" },
        ["@function.method.call"] = { fg = "$yellow" },

        -- Destaque do Illuminate
        IlluminatedWordRead = { fg = "$fg", bg = "$bg1" },
        IlluminatedWordWrite = { fg = "$fg", bg = "$bg1" },
      }, -- Override highlight groups

      -- Plugins Config --
      diagnostics = {
        darker = true, -- darker colors for diagnostic
        undercurl = true, -- use undercurl instead of underline for diagnostics
        background = true, -- use background color for virtual text
      },
    })
    require("onedark").load()
  end,
}
