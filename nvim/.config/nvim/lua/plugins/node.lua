local function has_file_in_project(ctx, names)
  return #vim.fs.find(names, { path = ctx.dirname, upward = true, limit = 1 }) > 0
end

local function package_json_for_current_buffer()
  return vim.fs.find("package.json", { path = vim.api.nvim_buf_get_name(0), upward = true, limit = 1 })[1]
end

local function package_manager(root, package)
  local from_package_manager = type(package.packageManager) == "string" and package.packageManager:match("^(%a+)")
  local commands = {
    bun = { "bun", "run" },
    pnpm = { "pnpm", "run" },
    yarn = { "yarn", "run" },
    npm = { "npm", "run" },
  }
  if commands[from_package_manager] then
    return commands[from_package_manager]
  end

  for _, lockfile in ipairs({
    { "bun.lockb", commands.bun },
    { "bun.lock", commands.bun },
    { "pnpm-lock.yaml", commands.pnpm },
    { "yarn.lock", commands.yarn },
    { "package-lock.json", commands.npm },
  }) do
    if vim.uv.fs_stat(root .. "/" .. lockfile[1]) then
      return lockfile[2]
    end
  end

  return commands.npm
end

local function read_current_package()
  local package_json = package_json_for_current_buffer()
  if not package_json then
    return nil
  end

  local ok, package = pcall(vim.json.decode, table.concat(vim.fn.readfile(package_json), "\n"))
  if not ok or type(package) ~= "table" then
    return nil
  end

  return vim.fs.dirname(package_json), package
end

local prettier_configs = {
  ".prettierrc",
  ".prettierrc.json",
  ".prettierrc.yml",
  ".prettierrc.yaml",
  ".prettierrc.js",
  ".prettierrc.cjs",
  ".prettierrc.mjs",
  "prettier.config.js",
  "prettier.config.cjs",
  "prettier.config.mjs",
}

local function project_uses_prettier(_, ctx)
  if has_file_in_project(ctx, prettier_configs) then
    return true
  end

  local package_json = vim.fs.find("package.json", { path = ctx.dirname, upward = true, limit = 1 })[1]
  if not package_json then
    return false
  end

  local ok, package = pcall(vim.json.decode, table.concat(vim.fn.readfile(package_json), "\n"))
  if not ok or type(package) ~= "table" then
    return false
  end

  if package.prettier ~= nil then
    return true
  end

  for _, field in ipairs({ "dependencies", "devDependencies", "peerDependencies" }) do
    if package[field] and package[field].prettier then
      return true
    end
  end

  return false
end

return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      formatters_by_ft = {
        javascript = { "biome", "prettier", stop_after_first = true },
        javascriptreact = { "biome", "prettier", stop_after_first = true },
        typescript = { "biome", "prettier", stop_after_first = true },
        typescriptreact = { "biome", "prettier", stop_after_first = true },
        json = { "biome", "prettier", stop_after_first = true },
        jsonc = { "biome", "prettier", stop_after_first = true },
      },
      formatters = {
        biome = {
          condition = function(_, ctx)
            return has_file_in_project(ctx, { "biome.json", "biome.jsonc" })
          end,
        },
        prettier = {
          condition = project_uses_prettier,
        },
      },
      format_on_save = function(bufnr)
        local javascript_filetypes = {
          javascript = true,
          javascriptreact = true,
          typescript = true,
          typescriptreact = true,
          json = true,
          jsonc = true,
        }

        if javascript_filetypes[vim.bo[bufnr].filetype] then
          return { timeout_ms = 2000, lsp_format = "fallback" }
        end
      end,
    },
    keys = {
      {
        "<leader>nf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        desc = "Format Node buffer",
      },
    },
  },
  {
    "stevearc/overseer.nvim",
    cmd = { "OverseerRun", "OverseerToggle" },
    opts = {
      task_list = {
        direction = "bottom",
        min_height = 12,
        max_height = 20,
        default_detail = 1,
      },
    },
    config = function(_, opts)
      require("overseer").setup(opts)
      require("overseer").register_template({
        name = "Node package script",
        builder = function(params)
          local root, package = read_current_package()
          if not root or type(package.scripts) ~= "table" then
            return nil
          end

          return {
            cmd = vim.list_extend(package_manager(root, package), { params.script }),
            cwd = root,
            components = { "default" },
          }
        end,
        params = {
          script = {
            type = "enum",
            choices = function()
              local _, package = read_current_package()
              if type(package and package.scripts) ~= "table" then
                return {}
              end
              return vim.tbl_keys(package.scripts)
            end,
          },
        },
      })
      vim.keymap.set("n", "<leader>nr", "<cmd>OverseerRun Node package script<cr>", { desc = "Run package script" })
      vim.keymap.set("n", "<leader>nt", "<cmd>OverseerToggle<cr>", { desc = "Toggle tasks" })
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
    },
    opts = function()
      return {
        adapters = {
          require("neotest-jest")({}),
          require("neotest-vitest")({}),
        },
      }
    end,
    keys = {
      {
        "<leader>tt",
        function()
          require("neotest").run.run()
        end,
        desc = "Run nearest test",
      },
      {
        "<leader>tT",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run test file",
      },
      {
        "<leader>ta",
        function()
          require("neotest").run.run(vim.fn.getcwd())
        end,
        desc = "Run all tests",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "Test output",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Test summary",
      },
    },
  },
}
