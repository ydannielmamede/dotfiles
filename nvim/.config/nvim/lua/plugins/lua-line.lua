return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local matugen_theme = {
        normal = {
          a = "MatugenLualineNormalA",
          b = "MatugenLualineNormalB",
          c = "MatugenLualineNormalC",
        },
        insert = {
          a = "MatugenLualineInsertA",
          b = "MatugenLualineInsertB",
          c = "MatugenLualineInsertC",
        },
        visual = {
          a = "MatugenLualineVisualA",
          b = "MatugenLualineVisualB",
          c = "MatugenLualineVisualC",
        },
        replace = {
          a = "MatugenLualineReplaceA",
          b = "MatugenLualineReplaceB",
          c = "MatugenLualineReplaceC",
        },
        command = {
          a = "MatugenLualineCommandA",
          b = "MatugenLualineCommandB",
          c = "MatugenLualineCommandC",
        },
        inactive = {
          a = "MatugenLualineInactiveA",
          b = "MatugenLualineInactiveB",
          c = "MatugenLualineInactiveC",
        },
      }

      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = matugen_theme,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          always_show_tabline = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
            refresh_time = 16, -- ~60fps
            events = {
              "WinEnter",
              "BufEnter",
              "BufWritePost",
              "SessionLoadPost",
              "FileChangedShellPost",
              "VimResized",
              "Filetype",
              "CursorMoved",
              "CursorMovedI",
              "ModeChanged",
            },
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      })
    end,
  },
}
