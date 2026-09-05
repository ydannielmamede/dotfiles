return {
  "emrearmagan/dockyard.nvim",
  cmd = { "Dockyard", "DockyardFloat" },
  keys = {
    { "<leader>dd", "<cmd>DockyardFloat<CR>", desc = "Docker Float" },
  },
  lazy = true,
  config = function()
    require("dockyard").setup({})
  end,
}
