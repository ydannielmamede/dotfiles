return {
  {
    "CRAG666/code_runner.nvim",
    config = function()
      require("code_runner").setup({
        filetype = {
          pascal = "cd $dir && fpc $fileName && $dir/$fileNameWithoutExt",
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

      local function run_java_file(file)
        local root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(vim.fn.expand("%:p:h")) .. " rev-parse --show-toplevel")[1]
        if vim.v.shell_error ~= 0 or root == nil or root == "" then
          root = vim.fn.getcwd()
        end

        local package = nil
        for line in io.lines(file) do
          package = line:match("^%s*package%s+([%w_.]+)%s*;")
          if package then
            break
          end
        end

        local class_name = vim.fn.expand("%:t:r")
        local main_class = package and (package .. "." .. class_name) or class_name
        local cmd = table.concat({
          "cd " .. vim.fn.shellescape(root),
          "mkdir -p bin",
          "javac -d bin $(find . -name '*.java' -not -path './bin/*')",
          "java -cp bin " .. vim.fn.shellescape(main_class),
        }, " && ")

        vim.cmd("belowright split | terminal " .. cmd)
      end

      vim.keymap.set("n", "<leader>r", function()
        local file = vim.fn.expand("%:p")
        local ft = vim.bo.filetype

        if ft == "lua" then
          vim.cmd("belowright split | terminal lua " .. vim.fn.shellescape(file))
        elseif ft == "java" then
          run_java_file(file)
        else
          vim.cmd("RunCode")
        end
      end, { noremap = true, silent = true })
    end,
  },
}
