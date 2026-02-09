return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        direction = "horizontal",   -- terminal na parte de baixo
        size = 10,                  -- altura em linhas
        open_mapping = [[<C-\>]],   -- atalho Ctrl+\
      })
    end,
  },
}

