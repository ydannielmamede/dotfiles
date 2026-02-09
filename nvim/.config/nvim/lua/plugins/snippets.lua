return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets", -- snippets do VSCode
    },
    config = function()
      -- carrega snippets no formato VSCode
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
}

