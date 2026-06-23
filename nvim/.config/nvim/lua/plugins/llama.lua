return {
  "ggml-org/llama.vim",
  init = function()
    vim.g.llama_config = {
      endpoint = "http://localhost:8085/infill", -- endpoint padrão do llama-server
      n_prefix = 256,        -- linhas de contexto antes do cursor
      n_suffix = 64,         -- linhas de contexto depois do cursor
      n_predict = 128,       -- tokens máximos a gerar
      t_max_prompt_ms = 500, -- timeout do prompt
      t_max_predict_ms = 1000, -- timeout da geração
      show_info = true,     -- desliga info extra (tokens/s etc)
      auto_fim = true,       -- ativa sugestão automática enquanto digita
    }
  end,
}
