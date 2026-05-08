return {
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      -- Configurações da interface
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_navigation = 1
      
      -- Atalho para abrir a interface
      vim.keymap.set('n', '<leader>db', ':DBUIToggle<CR>', { desc = "Toggle DBUI" })
    end,
    config = function()
      -- Configuração para autocompletar via nvim-cmp
      local group = vim.api.nvim_create_augroup('dadbod_setup', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        group = group,
        pattern = { 'sql', 'mysql', 'plsql' },
        callback = function()
          require('cmp').setup.buffer({
            sources = { { name = 'vim-dadbod-completion' } }
          })
        end,
      })
    end,
  },
}
