vim.lsp.config("emmet_language_server", {
  cmd = { "emmet-language-server", "--stdio" },
  filetypes = {
    "astro",
    "css",
    "eruby",
    "html",
    "htmlangular",
    "htmldjango",
    "javascriptreact",
    "less",
    "sass",
    "scss",
    "svelte",
    "typescriptreact",
    "vue",
  },

   root_markers = { '.git' },

  init_options = {
    showExpandedAbbreviation = "always",
    showAbbreviationSuggestions = true,
  },
})

vim.lsp.enable("emmet_language_server")
