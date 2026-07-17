return {
  {
    "RRethy/base16-nvim",
    name = "base16-nvim",
    priority = 999,
    config = function()
      require("matugen").setup()
    end,
  },
}
