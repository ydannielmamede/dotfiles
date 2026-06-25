#!/usr/bin/env bash
set -euo pipefail

WORKDIR=$(git rev-parse --show-toplevel 2>/dev/null || true)
if [[ -z "$WORKDIR" ]]; then
  echo "Erro: rode o script dentro de um repositório git." >&2
  exit 1
fi

LOGDIR="${TMPDIR:-/tmp}/ia-stack"
SLOTDIR="/home/dannielmamede/.cache/ia-stack/slots"
mkdir -p "$LOGDIR" "$SLOTDIR"

# Cores ANSI (desativadas se stdout não for TTY)
if [[ -t 1 ]]; then
  C_RESET=$'\033[0m'
  C_BOLD=$'\033[1m'
  C_DIM=$'\033[2m'
  C_GREEN=$'\033[32m'
  C_YELLOW=$'\033[33m'
  C_BLUE=$'\033[34m'
  C_CYAN=$'\033[36m'
else
  C_RESET=""; C_BOLD=""; C_DIM=""
  C_GREEN=""; C_YELLOW=""; C_BLUE=""; C_CYAN=""
fi

# Armazena PIDs dos servidores iniciados por este run para reportar depois.
STARTED_PIDS=()

cleanup() {
  jobs -pr | xargs -r kill
}
trap cleanup EXIT INT TERM

port_open() {
  timeout 1 bash -c "</dev/tcp/127.0.0.1/$1" 2>/dev/null
}

wait_port() {
  until port_open "$1"; do
    sleep 0.2
  done
}

# Header visual do run
printf '\n%s=== IA Stack ===%s\n' "$C_BOLD$C_CYAN" "$C_RESET"
printf '%sWORKDIR%s : %s%s%s\n' "$C_DIM" "$C_RESET" "$C_BOLD" "$WORKDIR" "$C_RESET"
printf '%sLOGS%s    : %s\n' "$C_DIM" "$C_RESET" "$LOGDIR"
printf '%sSLOTS%s   : %s\n\n' "$C_DIM" "$C_RESET" "$SLOTDIR"

# Sempre reinicia o mcp-proxy para usar o WORKDIR atual
pkill -f "mcp-proxy" 2>/dev/null || true
pkill -f "server-filesystem" 2>/dev/null || true
sleep 0.3

npx -y mcp-proxy \
  --host 127.0.0.1 \
  --port 3333 \
  --server sse \
  -- npx -y @modelcontextprotocol/server-filesystem "$WORKDIR" \
  >"$LOGDIR/mcp-proxy.log" 2>&1 &
STARTED_PIDS+=("mcp-proxy:$!:/usr/bin/npx")

LLAMA_STARTED=false
if ! port_open 1111; then
  LLAMA_STARTED=true
  llama-server \
    -m /home/dannielmamede/IA/models/Qwen3-8B-Q4_K_M.gguf \
    --jinja \
    --host 127.0.0.1 \
    --port 1111 \
    --ctx-size 10000 \
    --n-gpu-layers 99 \
    --parallel 1 \
    --ui-mcp-proxy \
    --mlock \
    --cache-prompt \
    --cache-reuse 256 \
    --cache-ram 10240 \
    --cache-idle-slots \
    --slot-save-path "$SLOTDIR" \
    --reasoning on \
    --reasoning-budget 512 \
    --reasoning-format deepseek \
    >"$LOGDIR/llama-server.log" 2>&1 &
  STARTED_PIDS+=("llama-server:$!:/usr/bin/llama-server")
fi

wait_port 1111
wait_port 3333

# Status final dos servidores
printf '%sServidores ativos:%s\n' "$C_BOLD" "$C_RESET"
if $LLAMA_STARTED; then
  printf '  %s[ligado]%s     %sllama-server%s       %shttp://127.0.0.1:1111%s   %sPID=%s%s  log=%s/llama-server.log\n' \
    "$C_GREEN" "$C_RESET" \
    "$C_BOLD" "$C_RESET" \
    "$C_BLUE" "$C_RESET" \
    "$C_DIM" "$(echo "${STARTED_PIDS[@]}" | grep -oP 'llama-server:\K[0-9]+' | head -1)" "$C_RESET" \
    "$LOGDIR"
else
  printf '  %s[já rodando]%s %sllama-server%s       %shttp://127.0.0.1:1111%s           log=%s/llama-server.log\n' \
    "$C_YELLOW" "$C_RESET" \
    "$C_BOLD" "$C_RESET" \
    "$C_BLUE" "$C_RESET" \
    "$LOGDIR"
fi
printf '  %s[ligado]%s     %smcp-proxy%s          %shttp://127.0.0.1:3333%s           log=%s/mcp-proxy.log\n' \
  "$C_GREEN" "$C_RESET" \
  "$C_BOLD" "$C_RESET" \
  "$C_BLUE" "$C_RESET" \
  "$LOGDIR"
printf '  %s[sse]%s        %sserver-filesystem%s %ssse://127.0.0.1:3333%s           WORKDIR=%s%s%s\n\n' \
  "$C_CYAN" "$C_RESET" \
  "$C_BOLD" "$C_RESET" \
  "$C_BLUE" "$C_RESET" \
  "$C_DIM" "$WORKDIR" "$C_RESET"

printf '%s✓ Stack IA pronta.%s Diretório: %s%s%s\n\n' \
  "$C_GREEN$C_BOLD" "$C_RESET" "$C_BOLD" "$WORKDIR" "$C_RESET"

SYSTEM_PROMPT=$(cat <<EOF
Você é uma IA local de programação, rápida e objetiva, integrada a um ambiente de desenvolvimento via MCP.

Diretório de trabalho atual: $WORKDIR
Use o servidor MCP filesystem para listar, ler, criar e editar arquivos dentro desse diretório.

Sobre caminhos:
- SEMPRE use paths RELATIVOS ao diretório de trabalho (ex: "app/models.py", nunca "/app/models.py" nem "/home/.../app/models.py").
- O servidor MCP filesystem rejeita paths absolutos e qualquer acesso fora do diretório do projeto.
- Antes de assumir a estrutura do projeto, liste o conteúdo do diretório se necessário — não presuma nomes de pastas ou arquivos.

Regras gerais:
- Responda em português.
- Seja curto, direto e prático.
- Priorize código funcional e simples.
- Leia só os arquivos necessários.
- Edite só o mínimo necessário.
- Não invente caminhos, arquivos, APIs ou bibliotecas.
- Não explique teoria se não for pedido.
- Ao editar código, informe apenas: arquivos alterados e resumo.
- Se houver erro, diga a causa provável e a correção.
- Se faltar dado essencial, faça uma única pergunta curta.
EOF
)

/home/dannielmamede/.local/bin/mcphost-local \
  --stream=false \
  --system-prompt "$SYSTEM_PROMPT" \
  "$@"
