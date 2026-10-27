return {
  {
    "CRAG666/code_runner.nvim",
    cmd = { "RunCode", "RunFile", "RunProject", "RunClose" },
    keys = {
      { "<leader>r", desc = "Run code / current file" },
    },
    config = function()
      local is_windows = vim.fn.has("win32") == 1
      local python = is_windows and "python -u" or "python3 -u"
      local c = is_windows
          and "cd /d $dir && gcc $fileName -o $fileNameWithoutExt.exe && $fileNameWithoutExt.exe"
        or "cd $dir && gcc $fileName -o /tmp/$fileNameWithoutExt && /tmp/$fileNameWithoutExt"
      local rust = is_windows
          and { "cd /d $dir &&", "rustc $fileName &&", "$fileNameWithoutExt.exe" }
        or { "cd $dir &&", "rustc $fileName &&", "$dir/$fileNameWithoutExt" }

      require("code_runner").setup({
        filetype = {
          pascal = "cd $dir && fpc $fileName && $dir/$fileNameWithoutExt",
          python = python,
          typescript = "deno run",
          rust = rust,
          c = c,
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
        local cmd
        if is_windows then
          cmd = string.format(
            'powershell -NoProfile -Command "Set-Location \'%s\'; if (!(Test-Path bin)) { New-Item -ItemType Directory -Path bin | Out-Null }; javac -d bin (Get-ChildItem -Recurse -Filter *.java -Exclude bin).FullName; java -cp bin %s"',
            root:gsub("'", "''"),
            main_class
          )
        else
          cmd = table.concat({
            "cd " .. vim.fn.shellescape(root),
            "mkdir -p bin",
            "javac -d bin $(find . -name '*.java' -not -path './bin/*')",
            "java -cp bin " .. vim.fn.shellescape(main_class),
          }, " && ")
        end

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
      end, { noremap = true, silent = true, desc = "Run code / current file" })
    end,
  },
}
