vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = vim.split(package.path, ";"),
      },
      diagnostics = {
        globals = { "vim" },
        disable = { "missing-fields" },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          vim.fn.stdpath("config"),
          "${3rd}/luv/library",
        },
      },
      completion = {
        callSnippet = "Replace",
        displayContext = 10,
        keywordSnippet = "Disable",
      },
      hint = {
        enable = true,
        arrayIndex = "Disable",
        await = true,
        paramName = "Disable",
        paramType = true,
        semicolon = "Disable",
        setType = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

-- clangd específico para Arduino --------------------------------------------------
-- Arduino .ino files exigem includes mágicos (Arduino.h, std::String, etc).
-- O clangd resolve isso via compile_commands.json — geramos automaticamente
-- via `:ArduinoInitLsp`. Veja lua/config/arduino.lua.
vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "-j=4",
  },
  init_options = {
    clangdFileStatus = true,
    usePlaceholders = true,
  },
  filetypes = { "c", "cpp", "arduino", "objc", "objcpp", "cuda" },
  -- Em .ino, força o filetype cpp pra herdar includes
  single_file_support = true,
})

vim.lsp.enable("pyright")
vim.lsp.enable("ruff")
-- vim.lsp.enable("jdtls")
vim.lsp.enable("lua_ls")
vim.lsp.enable("bashls")
vim.lsp.enable("vimls")
vim.lsp.enable("html")
vim.lsp.enable("cssls")
vim.lsp.enable("ts_ls")
-- vim.lsp.enable("hyprls")
vim.lsp.enable("clangd")
vim.lsp.enable("taplo")
vim.lsp.enable("lemminx")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("dockerls")
vim.lsp.enable("docker_compose_language_service")
vim.lsp.enable("nginx_language_server")
vim.lsp.enable("omnisharp")
vim.lsp.enable("sqls")
vim.lsp.enable("djlsp")
