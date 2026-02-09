return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- or if using mini.icons/mini.nvim
  -- dependencies = { "nvim-mini/mini.icons" },
  ---@module "fzf-lua"
  ---@type fzf-lua.Config|{}
  ---@diagnostic disable: missing-fields
  opts = {
      files = {
         cwd = vim.fn.expand("~"),
     }
  },
  keys = {
    { "<leader>ff", function() require("fzf-lua").files() end, desc = "Arquivos" },
    { "<leader>fg", function() require("fzf-lua").live_grep() end, desc = "Grep" },
    { "<leader>fb", function() require("fzf-lua").buffers() end, desc = "Buffers" },
    { "<leader>fr", function() require("fzf-lua").oldfiles() end, desc = "Recentes" },
  },

  ---@diagnostic enable: missing-fields
}
