return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    require("nvim-treesitter").setup({
      ensure_installed = { "python", "html", "css", "javascript" },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    })
  end,
}
