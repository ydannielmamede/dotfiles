return {
  {
    "saghen/blink.cmp",
    version = "1.*", -- usa binários pré-compilados
    dependencies = {
      "rafamadriz/friendly-snippets",
      "L3MON4D3/LuaSnip",
    },

    opts = {
      -- KEYMAP PERSONALIZADO
      keymap = {
        preset = "none",

        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"]     = { "hide", "fallback" },

        ["<Tab>"] = {
          "select_next",
          "snippet_forward",
          "fallback",
        },

        ["<S-Tab>"] = {
          "select_prev",
          "snippet_backward",
          "fallback",
        },

        ["<CR>"] = {
          "accept",
          "fallback",
        },

        ["<Up>"]   = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },

        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },

        ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
      },

      -- APARÊNCIA
      appearance = {
        nerd_font_variant = "mono",
      },

      -- DOCUMENTAÇÃO
      completion = {
        documentation = {
          auto_show = false,
        },
      },

      -- SNIPPETS
      snippets = {
        expand = function(snippet)
          require("luasnip").lsp_expand(snippet)
        end,
      },

      -- SOURCES
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },

      -- FUZZY MATCHING
      fuzzy = {
        implementation = "prefer_rust_with_warning",
      },
    },

    opts_extend = { "sources.default" },
  },
}

