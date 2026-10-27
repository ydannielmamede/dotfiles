return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local lualine = require("lualine")

      local function hl_color(group, attr, fallback)
        local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
        local val = hl and hl[attr]
        if val then
          return string.format("#%06x", val)
        end
        return fallback
      end

      local function get_theme_colors()
        local bg = hl_color("StatusLine", "bg", hl_color("Normal", "bg", "#1e2227"))
        local fg = hl_color("StatusLine", "fg", hl_color("Normal", "fg", "#abb2bf"))

        return {
          bg = bg,
          fg = fg,
          yellow = hl_color("DiagnosticWarn", "fg", hl_color("Type", "fg", "#e5c07b")),
          cyan = hl_color("DiagnosticInfo", "fg", hl_color("Special", "fg", "#56b6c2")),
          green = hl_color("String", "fg", "#98c379"),
          orange = hl_color("DiagnosticWarn", "fg", hl_color("Constant", "fg", "#d19a66")),
          violet = hl_color("Statement", "fg", hl_color("Keyword", "fg", "#c678dd")),
          magenta = hl_color("Statement", "fg", "#c678dd"),
          blue = hl_color("Function", "fg", hl_color("Directory", "fg", "#61afef")),
          red = hl_color("DiagnosticError", "fg", hl_color("ErrorMsg", "#e06c75")),
        }
      end

      local conditions = {
        buffer_not_empty = function()
          return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
        end,
        hide_in_width = function()
          return vim.fn.winwidth(0) > 80
        end,
      }

      local function build_config()
        local colors = get_theme_colors()

        local config = {
          options = {
            icons_enabled = true,
            component_separators = "",
            section_separators = "",
            theme = {
              normal = { c = { fg = colors.fg, bg = colors.bg } },
              inactive = { c = { fg = colors.fg, bg = colors.bg } },
            },
            disabled_filetypes = {
              statusline = {},
              winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            always_show_tabline = true,
            globalstatus = true,
            refresh = {
              statusline = 500,
              tabline = 1000,
              winbar = 1000,
              refresh_time = 100,
              events = {
                "WinEnter",
                "BufEnter",
                "BufWritePost",
                "SessionLoadPost",
                "FileChangedShellPost",
                "VimResized",
                "Filetype",
                "ModeChanged",
              },
            },
          },
          sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
          },
          inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
          },
          tabline = {},
          winbar = {},
          inactive_winbar = {},
          extensions = {},
        }

        local function ins_left(component)
          table.insert(config.sections.lualine_c, component)
        end

        local function ins_right(component)
          table.insert(config.sections.lualine_x, component)
        end

        ins_left({
          function()
            return "▊"
          end,
          color = { fg = colors.blue },
          padding = { left = 0, right = 1 },
        })

        ins_left({
          function()
            return ""
          end,
          color = function()
            local mode_color = {
              n = colors.red,
              i = colors.green,
              v = colors.blue,
              ["\22"] = colors.blue,
              V = colors.blue,
              c = colors.magenta,
              no = colors.red,
              s = colors.orange,
              S = colors.orange,
              ["\19"] = colors.orange,
              ic = colors.yellow,
              R = colors.violet,
              Rv = colors.violet,
              cv = colors.red,
              ce = colors.red,
              r = colors.cyan,
              rm = colors.cyan,
              ["r?"] = colors.cyan,
              ["!"] = colors.red,
              t = colors.red,
            }
            return { fg = mode_color[vim.fn.mode()] or colors.fg }
          end,
          padding = { right = 1 },
        })

        ins_left({ "filesize", cond = conditions.buffer_not_empty })
        ins_left({
          "diagnostics",
          sources = { "nvim_diagnostic" },
          symbols = { error = " ", warn = " ", info = " " },
          diagnostics_color = {
            error = { fg = colors.red },
            warn = { fg = colors.yellow },
            info = { fg = colors.cyan },
          },
        })

        ins_left({
          function()
            return "%="
          end,
        })

        ins_left({
          function()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients == 0 then
              return "No Active LSP"
            end

            local names = {}
            for _, client in ipairs(clients) do
              table.insert(names, client.name)
            end
            return table.concat(names, ", ")
          end,
          icon = " LSP:",
          color = { fg = colors.fg, gui = "bold" },
        })

        ins_right({
          "o:encoding",
          fmt = string.upper,
          cond = conditions.hide_in_width,
          color = { fg = colors.green, gui = "bold" },
        })
        ins_right({
          "fileformat",
          fmt = string.upper,
          icons_enabled = false,
          color = { fg = colors.green, gui = "bold" },
        })
        ins_right({
          "branch",
          icon = "",
          color = { fg = colors.violet, gui = "bold" },
        })
        ins_right({
          "diff",
          symbols = { added = " ", modified = "󰝤 ", removed = " " },
          diff_color = {
            added = { fg = colors.green },
            modified = { fg = colors.orange },
            removed = { fg = colors.red },
          },
          cond = conditions.hide_in_width,
        })
        ins_right({
          function()
            return "▊"
          end,
          color = { fg = colors.blue },
          padding = { left = 1 },
        })

        return config
      end

      local function setup_lualine()
        lualine.setup(build_config())
      end

      setup_lualine()

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("LualineDynamicColors", { clear = true }),
        callback = function()
          vim.schedule(setup_lualine)
        end,
      })
    end,
  },
}
