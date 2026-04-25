return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    ensure_installed = { "markdown", "markdown_inline", "java", "python", "lua", "vim" },
    highlight = { 
      enable = true,
      -- Isso é importante: desativar highlight em arquivos muito grandes
      -- para evitar que o erro de range trave o Neovim
      disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,
    },
  },
}
