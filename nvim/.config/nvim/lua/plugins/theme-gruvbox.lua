return {
  "ellisonleao/gruvbox.nvim",
  priority = 1000,
  config = function()
    local is_light = vim.o.background == "light"

    require("gruvbox").setup({
      terminal_colors = true,
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true,
      contrast = "hard",
      palette_overrides = {},
      overrides = {
        Comment                  = { fg = is_light and "#7c6f64" or "#928374", italic = true },
        ["@variable"]            = { link = "GruvboxPurple" },
        ["@variable.builtin"]    = { link = "GruvboxPurple" },
        ["@variable.member"]     = { link = "GruvboxPurple" },
        ["@variable.parameter"]  = { link = "GruvboxPurple" },
      },
      dim_inactive = false,
      transparent_mode = true,
    })
    vim.cmd("colorscheme gruvbox")
  end,
}
