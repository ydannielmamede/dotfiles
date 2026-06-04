return {
  "mason-org/mason.nvim",
  config = function()
    require("mason").setup({
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry", -- para o roslyn
      },
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })
  end,
}
