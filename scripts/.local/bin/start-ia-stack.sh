#!/usr/bin/env bash
set -euo pipefail

WORKDIR=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
LOGDIR="${TMPDIR:-/tmp}/ia-stack"
SLOTDIR="/home/dannielmamede/.cache/ia-stack/slots"
mkdir -p "$LOGDIR" "$SLOTDIR"

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

if ! port_open 3333; then
  npx -y mcp-proxy \
    --host 127.0.0.1 \
    --port 3333 \
    --server sse \
    -- npx -y @modelcontextprotocol/server-filesystem "$WORKDIR" \
    >"$LOGDIR/mcp-proxy.log" 2>&1 &
fi

if ! port_open 1111; then
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
    >"$LOGDIR/llama-server.log" 2>&1 &
fi

wait_port 1111
wait_port 3333

printf 'Stack IA pronta. Diretório: %s\n' "$WORKDIR"

SYSTEM_PROMPT=$(cat <<EOF
Você é uma IA local de programação, rápida e objetiva.

Diretório atual: $WORKDIR
Use MCP filesystem para ler, criar e editar arquivos dentro desse diretório.

Regras:
- Responda em português.
- Seja curto, direto e prático.
- Priorize código funcional e simples.
- Leia só os arquivos necessários.
- Edite só o mínimo necessário.
- Não invente caminhos, arquivos, APIs ou bibliotecas.
- Não explique teoria se não for pedido.
- Dê comandos prontos para copiar.
- Ao editar código, informe apenas: arquivos alterados, resumo e como testar.
- Se houver erro, diga a causa provável e a correção.
- Se faltar dado essencial, faça uma única pergunta curta.
EOF
)

/home/dannielmamede/.local/bin/mcphost-local \
  --stream=false \
  --system-prompt "$SYSTEM_PROMPT" \
  "$@"
