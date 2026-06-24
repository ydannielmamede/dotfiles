#!/usr/bin/env bash
set -Eeuo pipefail

VENV_PATH="/home/dannielmamede/mcp/.venv/bin/activate"
MODEL_PATH="$HOME/IA/models/Qwen3-8B-Q4_K_M.gguf"
LOG_DIR="/home/dannielmamede/mcp/logs"
LLAMA_PORT=8085
FS_PORT=3333
MCPHOST_MODEL="${MCPHOST_MODEL:-openai:local}"
ROOT_DIR="${MCP_ROOT_DIR:-$(git -C "$PWD" rev-parse --show-toplevel 2>/dev/null || printf '%s' "$PWD")}"

pids=()

cleanup() {
    local code=$?
    trap - EXIT INT TERM
    if ((${#pids[@]})); then
        printf '\nEncerrando servidores...\n'
        kill "${pids[@]}" 2>/dev/null || true
        wait "${pids[@]}" 2>/dev/null || true
    fi
    exit "$code"
}
trap cleanup EXIT INT TERM

need() {
    command -v "$1" >/dev/null 2>&1 || {
        printf "Erro: comando '%s' não encontrado no PATH.\n" "$1" >&2
        exit 1
    }
}

port_in_use() {
    ss -ltn "sport = :$1" | grep -q LISTEN
}

wait_port() {
    local port="$1"
    for _ in {1..60}; do
        port_in_use "$port" && return 0
        sleep 1
    done
    printf "Erro: porta %s não abriu a tempo.\n" "$port" >&2
    exit 1
}

wait_http() {
    local url="$1"
    for _ in {1..60}; do
        curl -fsS "$url" >/dev/null 2>&1 && return 0
        sleep 1
    done
    printf "Erro: %s não respondeu a tempo.\n" "$url" >&2
    exit 1
}

[[ -f "$VENV_PATH" ]] || { printf "Erro: venv não encontrado em %s\n" "$VENV_PATH" >&2; exit 1; }
[[ -f "$MODEL_PATH" ]] || { printf "Erro: modelo não encontrado em %s\n" "$MODEL_PATH" >&2; exit 1; }

# shellcheck disable=SC1090
source "$VENV_PATH"

need llama-server
need mcp-proxy
need mcphost
need npx
need curl
need ss
need grep

mkdir -p "$LOG_DIR"
if port_in_use "$FS_PORT"; then
    printf "Erro: porta %s já está em uso; encerre esse processo ou mude FS_PORT.\n" "$FS_PORT" >&2
    exit 1
fi
if port_in_use "$LLAMA_PORT"; then
    printf "llama-server já está rodando em http://127.0.0.1:%s; vou reutilizar.\n" "$LLAMA_PORT"
    wait_http "http://127.0.0.1:$LLAMA_PORT/health"
else
    printf "Iniciando llama-server em http://127.0.0.1:%s\n" "$LLAMA_PORT"
    llama-server \
        -m "$MODEL_PATH" \
        --jinja \
        --host 127.0.0.1 \
        --port "$LLAMA_PORT" \
        --ctx-size 8192 \
        --n-gpu-layers 99 \
        --parallel 1 \
        --ui-mcp-proxy \
        >"$LOG_DIR/llama.log" 2>&1 &
    pids+=("$!")
    wait_http "http://127.0.0.1:$LLAMA_PORT/health"
fi

printf "Iniciando MCP filesystem em http://127.0.0.1:%s\n" "$FS_PORT"
mcp-proxy \
    --host=127.0.0.1 \
    --port="$FS_PORT" \
    --allow-origin="http://127.0.0.1:$LLAMA_PORT" \
    --allow-origin="http://localhost:$LLAMA_PORT" \
    -- npx -y @modelcontextprotocol/server-filesystem "$ROOT_DIR" \
    >"$LOG_DIR/filesystem.log" 2>&1 &
pids+=("$!")
wait_port "$FS_PORT"

printf '\nPronto. Abra http://127.0.0.1:%s\n' "$LLAMA_PORT"
printf 'Diretório MCP: %s\n' "$ROOT_DIR"
printf 'Logs: %s/{llama,filesystem}.log\n' "$LOG_DIR"
printf 'Ctrl+C encerra todos. Saia do mcphost para encerrar a stack.\n\n'

mcphost \
    --config "$HOME/.mcp.json" \
    --provider-url "http://127.0.0.1:$LLAMA_PORT/v1" \
    --provider-api-key "${MCPHOST_API_KEY:-sk-local}" \
    -m "$MCPHOST_MODEL" \
    --system-prompt "Você está trabalhando no diretório: $ROOT_DIR. Use o MCP filesystem para ler e editar arquivos nesse diretório."
