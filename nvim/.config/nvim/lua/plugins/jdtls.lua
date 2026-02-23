return {
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    config = function()
      local jdtls = require("jdtls")

      local root_markers = { "pom.xml", "build.gradle", ".git" }
      local root_dir = require("jdtls.setup").find_root(root_markers) or vim.fn.getcwd()
      local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspaces/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

      local mason_path = vim.fn.stdpath("data") .. "/mason"
      local jdtls_path = mason_path .. "/packages/jdtls"
      local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

      local uname = vim.loop.os_uname().sysname
      local config_os = (uname == "Darwin" and "config_mac") or (uname == "Windows_NT" and "config_win") or "config_linux"
      local config_path = jdtls_path .. "/" .. config_os

      local cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xms1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens", "java.base/java.util=ALL-UNNAMED",
        "--add-opens", "java.base/java.lang=ALL-UNNAMED",
        "-jar", launcher,
        "-configuration", config_path,
        "-data", workspace_dir,
      }

      local on_attach = function(_, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "K",  vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>fm", function() vim.lsp.buf.format({ async = true }) end, opts)
        vim.keymap.set("n", "<leader>oi", jdtls.organize_imports, opts)

        -- Seu atalho (code action "source")
        vim.keymap.set("n", "<leader>jg", function()
          vim.lsp.buf.code_action({ context = { only = { "source" } } })
        end, opts)

        jdtls.setup_dap({ hotcodereplace = "auto" })
        require("jdtls.dap").setup_dap_main_class_configs()
        jdtls.setup.add_commands()

        -- Comandos buffer-locais para build/run
        vim.api.nvim_buf_create_user_command(bufnr, "JavaBuild", function()
          vim.fn.jobstart({ "bash", "-lc", 'mkdir -p out && javac -d out $(git ls-files "src/**/*.java" 2>/dev/null || echo src/**/*.java)' }, { stdout_buffered = true })
        end, {})

        vim.api.nvim_buf_create_user_command(bufnr, "JavaRun", function()
          vim.fn.jobstart({ "bash", "-lc", "java -cp out conversor.Main" }, { stdout_buffered = true })
        end, {})
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()

      local settings = {
        java = {
          format = { enabled = true },
          project = { referencedLibraries = {} },
          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            },
          },
          contentProvider = { preferred = "fernflower" },
        },
      }

      jdtls.start_or_attach({
        cmd = cmd,
        root_dir = root_dir,
        on_attach = on_attach,
        capabilities = capabilities,
        settings = settings,
        init_options = { bundles = {} },
      })
    end,
  },
}
