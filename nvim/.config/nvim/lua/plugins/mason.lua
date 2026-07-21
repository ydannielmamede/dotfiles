return {
  {
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
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "jdtls",
        "java-debug-adapter",
        "java-test",
        "google-java-format",
        "pyright",
        "ruff",
        "black",
        "djlint",
        "django-template-lsp",
        "debugpy",
        "lua-language-server",
        "stylua",
        "selene",
        "dockerfile-language-server",
        "docker-compose-language-service",
        "hadolint",
        "prettier",
      },
      auto_update = false,
      run_on_start = true,
    },
  },
}
