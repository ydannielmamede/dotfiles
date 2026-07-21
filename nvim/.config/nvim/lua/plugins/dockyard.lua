return {
  "emrearmagan/dockyard.nvim",
  cmd = { "Dockyard", "DockyardFloat" },
  keys = {
    { "<leader>d", "<cmd>DockyardFloat<CR>", desc = "Docker Float" },
  },
  lazy = true,
  config = function()
    require("dockyard").setup({})
  end,
}
