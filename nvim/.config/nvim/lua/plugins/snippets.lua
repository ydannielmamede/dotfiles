return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local ls = require("luasnip")
      local s = ls.snippet
      local i = ls.insert_node
      local t = ls.text_node
      local f = ls.function_node

      require("luasnip.loaders.from_vscode").lazy_load({ exclude = { "java" } })

      ls.add_snippets("java", {
        s("class", {
          t("public class "),
          f(function()
            return vim.fn.expand("%:t:r")
          end),
          t({ " {", "\t" }),
          i(0),
          t({ "", "}" }),
        }),
        s("main", {
          t({ "public static void main(String[] args) {", "\t" }),
          i(0),
          t({ "", "}" }),
        }),
        s("sout", {
          t("System.out.println("),
          i(1),
          t(");"),
        }),
      })
    end,
  },
}
