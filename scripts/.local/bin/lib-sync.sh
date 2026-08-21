#!/bin/bash

sync_format_bytes() {
    awk -v bytes="${1:-0}" 'BEGIN {
        split("B KiB MiB GiB TiB", units, " ")
        unit_index = 1
        while (bytes >= 1024 && unit_index < 5) {
            bytes /= 1024
            unit_index++
        }
        if (unit_index == 1) {
            printf "%d %s", bytes, units[unit_index]
        } else {
            printf "%.1f %s", bytes, units[unit_index]
        }
    }'
}

sync_format_duration() {
    local seconds="${1:-0}"

    if [ "$seconds" -lt 1 ]; then
        printf '<1 s'
    elif [ "$seconds" -lt 60 ]; then
        printf '%s s' "$seconds"
    else
        printf '%sm %02ds' "$((seconds / 60))" "$((seconds % 60))"
    fi
}

sync_report_preserved_versions() {
    local direction="$1"
    local conflict_dir="$2"
    local preserved_count

    if [ "$direction" = "download" ]; then
        preserved_count="$(find "$conflict_dir" -type f 2>/dev/null | wc -l)"
        if [ "$preserved_count" -gt 0 ]; then
            printf '\nVersões preservadas (recupere-as de %s):\n' "$conflict_dir"
            find "$conflict_dir" -type f -printf '%P\n' 2>/dev/null | while IFS= read -r file; do
                printf '%s/%s\n' "$conflict_dir" "$file"
            done
        else
            printf '\nNenhum save existente precisou ser arquivado.\n'
        fi
    else
        preserved_paths="$(ssh sync "if [ -d '$conflict_dir' ]; then find '$conflict_dir' -type f -printf '%p\\n'; fi")" || {
            printf '\nNão foi possível consultar as versões preservadas em %s.\n' "$conflict_dir"
            return
        }
        if [ -n "$preserved_paths" ]; then
            printf '\nVersões preservadas no servidor (recupere-as de %s):\n%s\n' "$conflict_dir" "$preserved_paths"
        else
            printf '\nNenhum save existente precisou ser arquivado.\n'
        fi
    fi
}

sync_run_rsync() {
    local direction="$1"
    local content="$2"
    local conflict_dir="$3"
    shift 3

    local capture_file status_file status
    local transfer_count transfer_bytes elapsed average_rate progress_option transferred_label
    local start_time end_time

    if rsync --info=progress2 --version >/dev/null 2>&1; then
        progress_option='--info=progress2,name0,flist0,stats0'
    else
        progress_option='--progress'
    fi

    capture_file="$(mktemp "${TMPDIR:-/tmp}/sync-rsync.XXXXXX")" || return 1
    status_file="$(mktemp "${TMPDIR:-/tmp}/sync-status.XXXXXX")" || {
        rm -f "$capture_file"
        return 1
    }

    start_time="$(date +%s)"
    {
        if [ "$content" = "saves" ]; then
            rsync "$@" \
                --backup \
                --backup-dir="$conflict_dir" \
                --exclude='.sync-conflitos/' \
                --human-readable \
                "$progress_option" \
                --out-format='SYNC_ITEM|%i|%l|%n%L'
        else
            rsync "$@" \
                --update \
                --human-readable \
                "$progress_option" \
                --out-format='SYNC_ITEM|%i|%l|%n%L'
        fi
        printf '%s\n' "$?" > "$status_file"
    } 2>&1 | tee "$capture_file" | sed '/^SYNC_ITEM|/d'

    status="$(<"$status_file")"
    end_time="$(date +%s)"
    elapsed=$((end_time - start_time))
    rm -f "$status_file"

    if [ "$status" -ne 0 ]; then
        printf '\n[ERRO] Falha na sincronização (rsync: %s; duração: %s).\n' \
            "$status" "$(sync_format_duration "$elapsed")"
        rm -f "$capture_file"
        return "$status"
    fi

    read -r transfer_count transfer_bytes < <(
        awk -F '|' '
            /^SYNC_ITEM\|[<>]f/ { files++; bytes += $3 }
            END { printf "%d %d\n", files + 0, bytes + 0 }
        ' "$capture_file"
    )

    if [ "$direction:$content" = "download:saves" ]; then
        transferred_label='Saves baixados nesta sincronização'
    else
        transferred_label='Arquivos atualizados'
    fi

    if [ "$transfer_count" -gt 0 ]; then
        printf '\n%s:\n' "$transferred_label"
        awk -F '|' '/^SYNC_ITEM\|[<>]f/ { print "- " $4 }' "$capture_file"
    else
        printf '\nNenhum arquivo precisou ser atualizado.\n'
    fi

    if [ "$elapsed" -gt 0 ]; then
        average_rate="$(awk -v bytes="$transfer_bytes" -v seconds="$elapsed" 'BEGIN { printf "%.0f", bytes / seconds }')"
    else
        average_rate=0
    fi

    printf '\nResumo da sincronização:\n'
    printf '  Arquivos transferidos: %s\n' "$transfer_count"
    printf '  Dados transferidos: %s\n' "$(sync_format_bytes "$transfer_bytes")"
    printf '  Velocidade média: %s/s\n' "$(sync_format_bytes "$average_rate")"
    printf '  Duração: %s\n' "$(sync_format_duration "$elapsed")"

    if [ "$content" = "saves" ]; then
        sync_report_preserved_versions "$direction" "$conflict_dir"
    fi

    rm -f "$capture_file"
}

sync_run() {
    local direction="$1"
    local content="$2"
    local local_path remote_path action success_message error_message

    case "$direction:$content" in
        download:roms)
            local_path="$HOME/sync/roms/"
            remote_path="/home/syncsaves/sync/roms/"
            action="Baixando ROMs mais recentes do servidor..."
            success_message="ROMs baixadas com sucesso!"
            error_message="Erro ao baixar as ROMs. Verifique a conexão."
            ;;
        download:saves)
            local_path="$HOME/sync/saves/"
            remote_path="/home/syncsaves/sync/saves/"
            action="Baixando saves mais recentes do servidor..."
            success_message="Saves baixados com sucesso!"
            error_message="Erro ao baixar os saves. Verifique a conexão."
            ;;
        upload:saves)
            local_path="$HOME/sync/saves/"
            remote_path="/home/syncsaves/sync/saves/"
            action="Enviando saves atualizados para o servidor..."
            success_message="Saves enviados com sucesso!"
            error_message="Erro ao enviar os saves. Verifique a conexão."
            ;;
        *)
            printf 'Erro: operação de sincronização inválida: %s %s\n' "$direction" "$content"
            return 1
            ;;
    esac

    mkdir -p "$local_path" || return 1
    printf '%s\n' "$action"

    if [ "$content" = "saves" ]; then
        conflict_timestamp="$(date +%Y%m%d-%H%M%S)"
        if [ "$direction" = "download" ]; then
            conflict_dir="${local_path%/}/.sync-conflitos/$conflict_timestamp"
            mkdir -p "$conflict_dir" || return 1
        else
            conflict_dir="/home/syncsaves/sync/conflitos/$conflict_timestamp"
            ssh sync "mkdir -p '$conflict_dir'" || return 1
        fi
    else
        conflict_dir=''
    fi

    if [ "$direction" = "download" ]; then
        sync_run_rsync "$direction" "$content" "$conflict_dir" -az "sync:$remote_path" "$local_path"
    else
        sync_run_rsync "$direction" "$content" "$conflict_dir" -az "$local_path" "sync:$remote_path"
    fi
    status=$?

    if [ "$status" -ne 0 ]; then
        printf '%s\n' "$error_message"
        return "$status"
    fi

    printf '%s\n' "$success_message"
}
