return {
  {
    "CRAG666/code_runner.nvim",
    config = function()
      require("code_runner").setup({
        filetype = {
          pascal = "cd $dir && fpc $fileName && $dir/$fileNameWithoutExt",
          java = {
              "java-run",
          },
          python = "python3 -u",
          typescript = "deno run",
          rust = {
            "cd $dir &&",
            "rustc $fileName &&",
            "$dir/$fileNameWithoutExt",
          },
          c = "cd $dir && gcc $fileName -o /tmp/$fileNameWithoutExt && /tmp/$fileNameWithoutExt",
        },
      })

      vim.keymap.set("n", "<leader>r", function()
        local file = vim.fn.expand("%:p")
        local ft = vim.bo.filetype

        if ft == "lua" then
          vim.cmd("belowright split | terminal lua " .. file)
        else
          vim.cmd("RunCode")
        end
      end, { noremap = true, silent = true })
    end,
  },
}
