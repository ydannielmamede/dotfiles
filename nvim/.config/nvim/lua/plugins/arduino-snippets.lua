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

      -- Snippets Arduino (.ino, cpp) ------------------------------------------------
      local arduino_snippets = {
        -- setup() + loop() template
        s("skeleton", {
          t({ "void setup() {", "\t" }),
          i(1),
          t({ "", "}", "", "void loop() {", "\t" }),
          i(0),
          t({ "", "}" }),
        }),

        s("setup", {
          t("void setup() {\n\t"),
          i(0),
          t("\n}"),
        }),

        s("loop", {
          t("void loop() {\n\t"),
          i(0),
          t("\n}"),
        }),

        -- Serial
        s("sbegin", {
          t("Serial.begin("),
          i(1, "9600"),
          t(");"),
        }),

        s("sprint", {
          t("Serial.print("),
          i(1),
          t(");"),
        }),

        s("sprintln", {
          t("Serial.println("),
          i(1),
          t(");"),
        }),

        s("sprintf", {
          t({ "Serial.print(F(\"" }),
          i(1),
          t({ "\"));" }),
        }),

        s("sprintfln", {
          t({ "Serial.println(F(\"" }),
          i(1),
          t({ "\"));" }),
        }),

        s("sprintfmt", {
          t({ 'Serial.printf("' }),
          i(1),
          t({ '", ' }),
          i(2),
          t(");"),
        }),

        -- Pin I/O
        s("pinmode", {
          t("pinMode("),
          i(1),
          t(", "),
          i(2, "OUTPUT"),
          t(");"),
        }),

        s("dw", {
          t("digitalWrite("),
          i(1),
          t(", "),
          i(2, "HIGH"),
          t(");"),
        }),

        s("dr", {
          t("digitalRead("),
          i(1),
          t(");"),
        }),

        s("aw", {
          t("analogWrite("),
          i(1),
          t(", "),
          i(2),
          t(");"),
        }),

        s("ar", {
          t("analogRead("),
          i(1),
          t(");"),
        }),

        -- Timing
        s("delayms", {
          t("delay("),
          i(1, "1000"),
          t(");  // ms"),
        }),

        s("delayus", {
          t("delayMicroseconds("),
          i(1),
          t(");"),
        }),

        -- Interrupts
        s("isr", {
          t({ "void " }),
          i(1, "onChange"),
          t({ "() {", "\t" }),
          i(0),
          t({ "", "}" }),
        }),

        s("attach", {
          t("attachInterrupt(digitalPinToInterrupt("),
          i(1),
          t("), "),
          i(2, "callback"),
          t(", "),
          i(3, "CHANGE"),
          t(");"),
        }),

        -- Constants / defines
        s("def", {
          t("#define "),
          i(1, "NAME"),
          t(" "),
          i(0),
        }),

        s("const", {
          t("const "),
          i(1, "int"),
          t(" "),
          i(2, "name"),
          t(" = "),
          i(0),
          t(";"),
        }),

        -- Loop helpers
        s("for", {
          t({ "for (int " }),
          i(1, "i"),
          t({ " = 0; " }),
          f(function(args)
            return args[1][1]
          end, { 1 }),
          t({ " < " }),
          i(2, "10"),
          t({ "; " }),
          f(function(args)
            return args[1][1]
          end, { 1 }),
          t({ "++) {", "\t" }),
          i(0),
          t({ "", "}" }),
        }),

        -- LED blink helper (clássico)
        s("blink", {
          t({ "const int LED = " }),
          i(1, "13"),
          t({ ";", "", "void setup() {", "\tpinMode(LED, OUTPUT);", "}", "", "void loop() {", "\tdigitalWrite(LED, HIGH);", "\tdelay(" }),
          i(2, "500"),
          t({ ");", "\tdigitalWrite(LED, LOW);", "\tdelay(" }),
          f(function(args)
            return args[1][1]
          end, { 2 }),
          t({ ");", "}" }),
        }),
      }

      ls.add_snippets("arduino", arduino_snippets)
      ls.add_snippets("cpp", arduino_snippets)
    end,
  },
}
