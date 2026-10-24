return {
  "jamsjz/django.nvim",
  ft = { "python", "htmldjango" },
  config = function()
    require("django").setup()
  end,
}
