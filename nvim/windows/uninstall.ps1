[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$target = Join-Path $env:LOCALAPPDATA 'nvim'

if (-not (Test-Path -LiteralPath $target)) {
    Write-Host "Nenhuma configuração encontrada em '$target'."
    exit 0
}

$item = Get-Item -LiteralPath $target -Force
if ($item.LinkType -eq 'Junction') {
    # No Windows, rmdir ou Remove-Item em Junction remove apenas o link sem apagar o destino
    [System.IO.Directory]::Delete($target)
    Write-Host "Junção removida com sucesso de '$target'." -ForegroundColor Green
} else {
    Write-Warning "O caminho '$target' é um diretório real (não é Junction). Para evitar perda acidental de dados, não foi excluído."
}
