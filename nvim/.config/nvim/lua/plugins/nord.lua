return {
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.nord_contrast = true
      vim.g.nord_borders = false
      vim.g.nord_disable_background = true -- fundo transparente
      vim.g.nord_italic = false
      vim.g.nord_uniform_diff_background = true
      vim.g.nord_bold = false

      require("nord").set()
      vim.cmd("colorscheme nord")

      -- garante transparência total
      vim.cmd([[
        highlight Normal guibg=NONE ctermbg=NONE
        highlight NormalNC guibg=NONE ctermbg=NONE
        highlight EndOfBuffer guibg=NONE ctermbg=NONE
        highlight SignColumn guibg=NONE ctermbg=NONE
        highlight VertSplit guibg=NONE ctermbg=NONE
      ]])
    end,
  },
}

