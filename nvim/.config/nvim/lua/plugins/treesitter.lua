local languages = { "python", "html", "css", "javascript", "java" }
local html_like_filetypes = { "htmldjango", "jinja", "jinja.html" }

return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = function()
    require("nvim-treesitter").install(languages):wait(300000)
  end,
  config = function()
    require("nvim-treesitter").setup()

    vim.api.nvim_create_autocmd("FileType", {
      pattern = languages,
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = html_like_filetypes,
      callback = function()
        pcall(vim.treesitter.start, 0, "html")
      end,
    })
  end,
}
