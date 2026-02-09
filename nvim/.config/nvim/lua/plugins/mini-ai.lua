return {
  "echasnovski/mini.ai",
  event = "VeryLazy",
  opts = {
    -- Textobjects customizados (nil = padrão)
    custom_textobjects = nil,

    mappings = {
      -- Prefixos principais
      around = "a",
      inside = "i",

      -- Próximo / último
      around_next = "an",
      inside_next = "in",
      around_last = "al",
      inside_last = "il",

      -- Ir para bordas do textobject
      goto_left = "g[",
      goto_right = "g]",
    },

    -- Linhas analisadas para encontrar o objeto
    n_lines = 50,

    -- Estratégia de busca
    search_method = "cover_or_next",

    -- Mensagens informativas
    silent = false,
  },
}

