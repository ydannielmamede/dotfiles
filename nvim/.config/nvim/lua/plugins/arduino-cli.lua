-- Arduino CLI integration ---------------------------------------------------------
--
-- Wrapper simples sobre `arduino-cli`. Não exige plugin externo — o comando já
-- existe no sistema. Fornecemos:
--
--   :ArduinoBoard        lista/detecta placas conectadas
--   :ArduinoCompile      compila o sketch atual
--   :ArduinoUpload       compila + envia
--   :ArduinoMonitor      abre serial monitor (auto-detecta porta)
--   :ArduinoInit         cria sketch .ino no sketchbook
--   :ArduinoLibs         busca/instala bibliotecas
--   :ArduinoLspSetup     gera compile_commands.json pro clangd
--
-- Configuração: deixe o `arduino-cli` instalado (Arch: `pacman -S arduino-cli`
-- ou AUR). Primeira vez: rode `arduino-cli core install <board>` ou use o
-- Arduino IDE 2.x pra instalar os cores via GUI.
--
-- Atalhos (leader = espaço):
--   <leader>ab  :ArduinoBoard
--   <leader>ac  :ArduinoCompile
--   <leader>au  :ArduinoUpload
--   <leader>am  :ArduinoMonitor
--   <leader>al  :ArduinoLspSetup
--   <leader>an  :ArduinoInit (novo sketch)
--   <leader>ai  :ArduinoLibs

local M = {}

function M.detect_port()
  -- Tenta primeiro com `arduino-cli board list` (mais confiável).
  local handle = io.popen("arduino-cli board list --format json 2>/dev/null")
  if not handle then return nil end
  local json_str = handle:read("*a")
  handle:close()

  if not json_str or json_str == "" then return nil end
  local ok, parsed = pcall(vim.fn.json_decode, json_str)
  if not ok or not parsed or not parsed.detected_ports then return nil end

  for _, entry in ipairs(parsed.detected_ports) do
    if entry.port and entry.port.address then
      return entry.port.address
    end
  end
  return nil
end

function M.detect_fqbn()
  -- FQBN = Fully Qualified Board Name. Retorna o primeiro disponível.
  local handle = io.popen("arduino-cli board list --format json 2>/dev/null")
  if not handle then return nil end
  local json_str = handle:read("*a")
  handle:close()

  if not json_str or json_str == "" then return nil end
  local ok, parsed = pcall(vim.fn.json_decode, json_str)
  if not ok or not parsed or not parsed.detected_ports then return nil end

  for _, entry in ipairs(parsed.detected_ports) do
    if entry.matching_boards and #entry.matching_boards > 0 then
      return entry.matching_boards[1].fqbn
    end
  end
  return nil
end

-- Helper: roda um comando e mostra saída num split flutuante.
local function run_in_float(cmd, title)
  local out = vim.fn.systemlist(cmd)
  local lines = vim.list_extend({ "▶ " .. cmd }, out)
  -- Cria buffer scratch
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value("filetype", "log", { buf = buf })
  vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
  -- Janela flutuante
  local width = math.min(120, vim.o.columns - 4)
  local height = math.min(40, vim.o.lines - 4)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = 2,
    col = 2,
    style = "minimal",
    border = "rounded",
    title = " " .. (title or "arduino-cli") .. " ",
    title_pos = "center",
  })
  return buf, win
end

-- Comandos -----------------------------------------------------------------------

function M.board()
  local port = M.detect_port()
  local fqbn = M.detect_fqbn()
  if not port then
    vim.notify("[arduino] Nenhuma placa detectada. Conecte a placa e tente de novo.", vim.log.levels.WARN)
    return
  end
  vim.notify(string.format("[arduino] Porta: %s | FQBN: %s", port, fqbn or "(desconhecido)"), vim.log.levels.INFO)
  -- Salva FQBN pra próximos comandos
  vim.g.arduino_fqbn = fqbn
  vim.g.arduino_port = port
end

function M.compile()
  if not vim.g.arduino_fqbn then M.board() end
  if not vim.g.arduino_fqbn then return end

  local sketch = vim.fn.expand("%:p")
  if vim.fn.fnamemodify(sketch, ":e") ~= "ino" then
    vim.notify("[arduino] Buffer atual não é um sketch .ino", vim.log.levels.ERROR)
    return
  end

  -- Salva antes de compilar
  if vim.bo.modified then vim.cmd("write") end

  local cmd = string.format(
    "arduino-cli compile --fqbn %s --warnings all %s 2>&1",
    vim.g.arduino_fqbn,
    vim.fn.shellescape(sketch)
  )
  run_in_float(cmd, "arduino-cli compile")
end

function M.upload()
  if not vim.g.arduino_fqbn then M.board() end
  if not vim.g.arduino_fqbn then return end
  if not vim.g.arduino_port then
    vim.notify("[arduino] Nenhuma porta detectada", vim.log.levels.ERROR)
    return
  end

  local sketch = vim.fn.expand("%:p")
  if vim.fn.fnamemodify(sketch, ":e") ~= "ino" then
    vim.notify("[arduino] Buffer atual não é um sketch .ino", vim.log.levels.ERROR)
    return
  end
  if vim.bo.modified then vim.cmd("write") end

  -- IMPORTANTE: usar `compile --upload` (uma só passada) em vez de só `upload`,
  -- porque o `arduino-cli upload` exige que o sketch já tenha sido compilado
  -- anteriormente e o binário esteja acessível. Sem isso o upload falha com
  -- "missing compiled sketch" ou similar.
  local cmd = string.format(
    "arduino-cli compile --upload -p %s --fqbn %s %s 2>&1",
    vim.g.arduino_port,
    vim.g.arduino_fqbn,
    vim.fn.shellescape(sketch)
  )
  run_in_float(cmd, "arduino-cli compile --upload")
end

function M.monitor()
  if not vim.g.arduino_port then M.board() end
  if not vim.g.arduino_port then return end

  -- Usa toggleterm se disponível, senão cria janela split
  local ok, toggleterm = pcall(require, "toggleterm")
  if ok then
    local Terminal = require("toggleterm.terminal").Terminal
    local term = Terminal:new({
      cmd = string.format("arduino-cli monitor -p %s -c baudrate=9600", vim.g.arduino_port),
      direction = "horizontal",
      close_on_exit = false,
      on_open = function(t) t:resize(15) end,
    })
    term:toggle()
  else
    -- Fallback: terminal split
    vim.cmd("botright split")
    vim.cmd("terminal " .. string.format("arduino-cli monitor -p %s -c baudrate=9600", vim.g.arduino_port))
    vim.cmd("startinsert")
  end
end

function M.lsp_setup()
  -- Gera compile_commands.json para o clangd entender includes do Arduino.
  -- O arduino-cli tem um flag --build-property que injeta o JSON pro clangd.
  if not vim.g.arduino_fqbn then M.board() end
  if not vim.g.arduino_fqbn then return end

  local sketch = vim.fn.expand("%:p")
  if vim.fn.fnamemodify(sketch, ":e") ~= "ino" then
    vim.notify("[arduino] Buffer atual não é um sketch .ino", vim.log.levels.ERROR)
    return
  end

  local out_dir = vim.fn.expand("%:p:h") .. "/build"
  vim.fn.mkdir(out_dir, "p")

  local cmd = string.format(
    "arduino-cli compile --fqbn %s --build-property 'build.extra_flags=-DCOMPILER_CLANGD' --only-compilation-database --output-dir %s %s 2>&1",
    vim.g.arduino_fqbn,
    vim.fn.shellescape(out_dir),
    vim.fn.shellescape(sketch)
  )

  vim.notify("[arduino] Gerando compile_commands.json... (pode levar ~30s)", vim.log.levels.INFO)
  local out = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify("[arduino] Falha ao gerar compile_commands.json:\n" .. out, vim.log.levels.ERROR)
    return
  end
  vim.notify("[arduino] compile_commands.json gerado em " .. out_dir .. "\nReinicie o LSP com :LspRestart", vim.log.levels.INFO)

  -- Cria .clangd file no diretório do sketch apontando pro compile_commands.json
  local clangd_file = vim.fn.expand("%:p:h") .. "/.clangd"
  local f = io.open(clangd_file, "w")
  if f then
    f:write("CompileFlags:\n  CompilationDatabase: " .. out_dir .. "\n")
    f:close()
  end
end

function M.init_sketch()
  vim.ui.input({ prompt = "Nome do sketch: " }, function(name)
    if not name or name == "" then return end
    local sketch_path = vim.fn.expand("~/Arduino/" .. name .. "/" .. name .. ".ino")
    vim.fn.mkdir(vim.fn.fnamemodify(sketch_path, ":h"), "p")
    local f = io.open(sketch_path, "w")
    if f then
      f:write([[
void setup() {
  // put your setup code here, to run once:
}

void loop() {
  // put your main code here, to run repeatedly:
}
]])
      f:close()
      vim.cmd("edit " .. sketch_path)
    end
  end)
end

function M.libs()
  -- TUI via floating window com `arduino-cli lib search <query>`
  vim.ui.input({ prompt = "Buscar lib: " }, function(query)
    if not query or query == "" then
      query = ""
    end
    local cmd = string.format("arduino-cli lib search %s 2>&1", vim.fn.shellescape(query))
    run_in_float(cmd, "arduino-cli lib search")
  end)
end

-- Registra comandos --------------------------------------------------------------
vim.api.nvim_create_user_command("ArduinoBoard", M.board, { desc = "Detecta placa Arduino" })
vim.api.nvim_create_user_command("ArduinoCompile", M.compile, { desc = "Compila sketch atual" })
vim.api.nvim_create_user_command("ArduinoUpload", M.upload, { desc = "Compila e envia para placa" })
vim.api.nvim_create_user_command("ArduinoMonitor", M.monitor, { desc = "Abre serial monitor" })
vim.api.nvim_create_user_command("ArduinoLspSetup", M.lsp_setup, { desc = "Gera compile_commands.json pro clangd" })
vim.api.nvim_create_user_command("ArduinoInit", M.init_sketch, { desc = "Cria novo sketch" })
vim.api.nvim_create_user_command("ArduinoLibs", M.libs, { desc = "Busca libs no arduino-cli" })

-- Keymaps ------------------------------------------------------------------------
local map = vim.keymap.set
map("n", "<leader>ab", "<cmd>ArduinoBoard<CR>", { desc = "Arduino: detectar placa" })
map("n", "<leader>ac", "<cmd>ArduinoCompile<CR>", { desc = "Arduino: compilar" })
map("n", "<leader>au", "<cmd>ArduinoUpload<CR>", { desc = "Arduino: upload" })
map("n", "<leader>am", "<cmd>ArduinoMonitor<CR>", { desc = "Arduino: monitor serial" })
map("n", "<leader>al", "<cmd>ArduinoLspSetup<CR>", { desc = "Arduino: gerar compile_commands.json" })
map("n", "<leader>an", "<cmd>ArduinoInit<CR>", { desc = "Arduino: novo sketch" })
map("n", "<leader>ai", "<cmd>ArduinoLibs<CR>", { desc = "Arduino: buscar libs" })

-- Auto-detecta placa quando abre um .ino
vim.api.nvim_create_autocmd("FileType", {
  pattern = "arduino",
  callback = function()
    -- Pequeno delay pra dar tempo do USB estabilizar
    vim.defer_fn(function()
      if vim.g.arduino_port and vim.g.arduino_fqbn then return end
      M.board()
    end, 800)
  end,
})

-- Retorna spec vazio: o lazy.nvim precisa de um return mesmo quando o "plugin"
-- só registra comandos/keymaps. As dependências (toggleterm) já vêm do spec
-- import = "plugins" no config/lazy.lua.
return {}
