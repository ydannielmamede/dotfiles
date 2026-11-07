return {
  {
    "milanglacier/minuet-ai.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("minuet").setup({
        -- Provedor FIM (Fill-In-The-Middle) compatível com llama-server
        provider = "openai_fim_compatible",
        n_completions = 1,      -- 1 sugestão por vez para economizar VRAM na GPU
        context_window = 1024,  -- Janela de contexto compacta para manter latência mínima na RX 580

        provider_options = {
          openai_fim_compatible = {
            -- Minuet lê uma variável de ambiente para a chave; 'TERM' sempre existe no Linux
            api_key = "TERM",
            name = "Llama.cpp",
            -- Endpoint de completions (FIM) do llama-server
            end_point = "http://127.0.0.1:8080/v1/completions",
            model = "qwen2.5-coder-1.5b-instruct",
            stream = true,
            optional = {
              max_tokens = 64,  -- Tamanho ideal de completude rápida (inline)
              top_p = 0.9,
            },
            -- Template oficial FIM com tokens especiais do Qwen 2.5 Coder para llama.cpp
            template = {
              prompt = function(context_before_cursor, context_after_cursor, _)
                return "<|fim_prefix|>"
                  .. context_before_cursor
                  .. "<|fim_suffix|>"
                  .. context_after_cursor
                  .. "<|fim_middle|>"
              end,
              suffix = false,
            },
          },
        },

        -- Configurações de debounce e throttle para modo Copilot com IA local
        throttle = 1000,        -- Intervalo mínimo entre requisições (evita sobrecarregar a GPU)
        debounce = 400,         -- Aguarda 400ms de pausa na digitação para disparar a sugestão

        -- Modo Virtual Text (estilo Copilot / ghost text inline automático)
        virtualtext = {
          -- Ativa o trigger automático para todos os tipos de arquivo ("*")
          auto_trigger_ft = { "*" },
          auto_trigger_ignore_ft = { "TelescopePrompt", "fzf", "toggleterm", "help" },
          keymap = {
            -- Aceita a sugestão inteira
            accept = "<A-A>",
            -- Aceita apenas a linha atual da sugestão
            accept_line = "<A-a>",
            -- Aceita n linhas (ex: <A-z> seguido de 2 e Enter aceita 2 linhas)
            accept_n_lines = "<A-z>",
            -- Volta para a sugestão anterior ou dispara manualmente a requisição
            prev = "<A-[>",
            -- Próxima sugestão ou dispara manualmente a requisição
            next = "<A-]>",
            -- Descarta a sugestão atual
            dismiss = "<A-e>",
          },
          -- Não exibe o ghost text quando o popup menu do blink.cmp estiver ativo
          show_on_completion_menu = false,
        },
      })
    end,
  },
}
