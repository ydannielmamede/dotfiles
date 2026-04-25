return {
  "arakkkkk/kanban.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    require("kanban").setup({
      markdown = {
        description_folder = "./tasks/",
        list_head = "## ",
      },
    })

    vim.keymap.set("n", "<leader>kc", function()
      -- Procura kanban-tasks.md subindo os diretórios
      local function find_kanban(dir)
        local file = dir .. "/kanban-tasks.md"
        if vim.fn.filereadable(file) == 1 then
          return file
        end
        local parent = vim.fn.fnamemodify(dir, ":h")
        if parent == dir then
          return nil -- chegou na raiz, não achou
        end
        return find_kanban(parent)
      end

      local found = find_kanban(vim.fn.getcwd())

      if found then
        vim.cmd("KanbanOpen " .. vim.fn.fnameescape(found))
      else
        -- Não achou em lugar nenhum, cria no diretório atual
        local file = vim.fn.getcwd() .. "/kanban-tasks.md"
        vim.cmd("KanbanCreate " .. vim.fn.fnameescape(file))
        vim.cmd("KanbanOpen " .. vim.fn.fnameescape(file))
      end
    end, { desc = "Kanban: encontrar ou criar kanban-tasks.md" })
  end,
}
