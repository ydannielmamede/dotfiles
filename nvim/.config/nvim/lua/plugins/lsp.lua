return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      require("config.emmet")

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
        end,
      })
    end,
  },
}
