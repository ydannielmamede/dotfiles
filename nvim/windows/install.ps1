[CmdletBinding()]
param(
    [string]$DotfilesRoot = (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)),
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

$source = Join-Path $DotfilesRoot 'nvim\.config\nvim'
$target = Join-Path $env:LOCALAPPDATA 'nvim'

if (-not (Test-Path -LiteralPath (Join-Path $source 'init.lua') -PathType Leaf)) {
    throw "Configuração não encontrada em '$source'. Informe -DotfilesRoot com a raiz deste repositório."
}

if (Test-Path -LiteralPath $target) {
    $item = Get-Item -LiteralPath $target -Force
    $isJunctionToSource = $item.LinkType -eq 'Junction' -and $item.Target -contains $source

    if ($isJunctionToSource) {
        Write-Host "Neovim já aponta para: $source"
        exit 0
    }

    if (-not $Force) {
        throw @"
Já existe uma configuração em '$target'.
Faça backup dela e execute novamente, ou use -Force para removê-la.
Exemplo: Move-Item '$target' '${target}.backup'
"@
    }

    Remove-Item -LiteralPath $target -Recurse -Force
}

New-Item -ItemType Directory -Path (Split-Path -Parent $target) -Force | Out-Null
cmd /c "mklink /J `"$target`" `"$source`"" | Out-Host

if (-not (Test-Path -LiteralPath (Join-Path $target 'init.lua') -PathType Leaf)) {
    throw "Não foi possível criar a junção em '$target'."
}

Write-Host "Configuração do Neovim instalada em '$target'." -ForegroundColor Green
Write-Host "Abra uma nova janela do PowerShell e execute: nvim"
