# Neovim nativo no Windows

Esta pasta adiciona suporte ao **Neovim nativo do Windows** sem alterar a instalação que já funciona no Linux. A fonte da configuração é compartilhada:

- Linux: `nvim/.config/nvim` → `~/.config/nvim`
- Windows: `nvim/.config/nvim` → `%LOCALAPPDATA%\nvim`

O Windows armazena plugins, Mason, Treesitter, cache e estado separadamente em `%LOCALAPPDATA%`. Portanto, não compartilhe `~/.local/share/nvim` ou diretórios de dados entre os dois sistemas.

> Este guia é para `nvim.exe` executado no Windows. Para Neovim executado **dentro do WSL**, use a configuração Linux normal em `~/.config/nvim`.

## 1. Pré-requisitos

Abra o PowerShell e instale o `winget` caso ainda não esteja disponível. Depois, instale as dependências básicas:

```powershell
winget install --id Neovim.Neovim -e
winget install --id Git.Git -e
winget install --id BurntSushi.ripgrep.MSVC -e
winget install --id sharkdp.fd -e
```

Feche e abra o PowerShell para atualizar o `PATH`, então confirme:

```powershell
nvim --version
git --version
rg --version
fd --version
```

Se `fd` não for encontrado, localize o executável instalado pelo gerenciador de pacotes e acrescente o diretório ao `PATH` do usuário.

### Compilador usado pelo Treesitter

A configuração instala parsers do Treesitter e precisa de um compilador C. Instale o LLVM/Clang:

```powershell
winget install --id LLVM.LLVM -e
```

Feche e reabra o PowerShell. Se `clang --version` não funcionar, acrescente `C:\Program Files\LLVM\bin` ao `PATH` do usuário e abra outro terminal.

## 2. Baixar os dotfiles no Windows

Clone o repositório em um caminho do Windows, por exemplo:

```powershell
git clone <URL-DO-REPOSITORIO> $HOME\dotfiles
cd $HOME\dotfiles
```

Se o repositório já existe dentro do WSL, clone-o novamente no Windows. O Neovim nativo pode até ler `\\wsl$\...`, mas isso é mais lento e costuma causar problemas de permissões, observadores de arquivo e ferramentas externas.

## 3. Ativar a configuração

O instalador cria uma **junction** em `%LOCALAPPDATA%\nvim` apontando para a configuração compartilhada no repositório. Assim, uma alteração nos dotfiles vale para Linux e Windows.

No PowerShell, a partir da raiz do repositório:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\nvim\windows\install.ps1
```

Se o repositório estiver em outro local:

```powershell
.\nvim\windows\install.ps1 -DotfilesRoot 'C:\Users\SEU_USUARIO\dotfiles'
```

O script não sobrescreve uma configuração existente. Faça backup primeiro:

```powershell
Move-Item "$env:LOCALAPPDATA\nvim" "$env:LOCALAPPDATA\nvim.backup"
.\nvim\windows\install.ps1
```

Para removê-la posteriormente, sem apagar os dotfiles:

```powershell
.\nvim\windows\uninstall.ps1
```

## 4. Primeiro início

Abra o Neovim:

```powershell
nvim
```

Na primeira abertura, `lazy.nvim` será baixado e os plugins serão instalados. Aguarde o término e execute:

```vim
:Lazy sync
:MasonToolsInstall
:checkhealth
```

Reinicie o Neovim depois que a instalação terminar. Os downloads podem levar alguns minutos porque a configuração instala LSPs, formatadores, depuradores e parsers para várias linguagens.

## 5. Clipboard do Windows

O `clipboard = "unnamedplus"` da configuração funciona nativamente no Windows. Confira com:

```vim
:checkhealth clipboard
```

Copiar (`y`) e colar (`p`) no Neovim usam o clipboard do Windows; use `"+y` e `"+p` se quiser indicar o registro explicitamente.

## 6. Ferramentas opcionais por linguagem

O Mason instala muitos LSPs e formatadores automaticamente, mas algumas funcionalidades dependem de programas fora do Neovim. Instale somente o que usar.

### Java

```powershell
winget install --id EclipseAdoptium.Temurin.21.JDK -e
```

`jdtls`, adaptador de depuração e testes são gerenciados pelo Mason. Execute `:MasonToolsInstall` após o JDK estar disponível.

### Python

```powershell
winget install --id Python.Python.3.13 -e
```

A execução por `<leader>r` usa `python -u` no Windows. Para projetos, prefira um ambiente virtual:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
```

### JavaScript / TypeScript

```powershell
winget install --id OpenJS.NodeJS.LTS -e
winget install --id DenoLand.Deno -e
winget install --id pnpm.pnpm -e
```

### C/C++

O LLVM instalado acima oferece `clang`; para compilar via o atalho `<leader>r`, instale também o MSYS2/MinGW e deixe o diretório `mingw64\bin` no `PATH`:

```powershell
winget install --id MSYS2.MSYS2 -e
```

No terminal MSYS2 UCRT64, instale o compilador:

```bash
pacman -S --needed mingw-w64-ucrt-x86_64-gcc
```

Depois acrescente `C:\msys64\ucrt64\bin` ao `PATH` do Windows. A configuração chama `gcc` para C e `rustc` para Rust.

### Rust

```powershell
winget install --id Rustlang.Rustup -e
rustup default stable
```

### Docker, Nginx e Arduino

- Docker: instale o Docker Desktop e mantenha-o em execução.
- Nginx: os LSPs e formatadores são instalados pelo Mason; `hadolint` pode exigir instalação adicional conforme a plataforma.
- Arduino: instale o Arduino CLI e deixe `arduino-cli.exe` no `PATH`. Conecte a placa e verifique a porta com `arduino-cli board list`.

## Compatibilidade da configuração

Foram adicionadas verificações de plataforma à configuração compartilhada:

- `netrw` usa `start` no Windows e `xdg-open` no Linux;
- Code Runner usa `python` no Windows e `python3` no Linux;
- a execução C/Rust usa caminhos e extensão `.exe` próprios do Windows;
- a execução avulsa de Java usa PowerShell no Windows em vez de `mkdir -p` e `find`.

Nem todos os plugins precisam das ferramentas acima. Um plugin que dependa de uma ferramenta ausente só terá aquela função indisponível; abra `:checkhealth` e `:Mason` para identificar e instalar o que faltar.

## Atualizar

Atualize o clone do Windows normalmente:

```powershell
cd $HOME\dotfiles
git pull
```

Em seguida, dentro do Neovim:

```vim
:Lazy sync
:MasonToolsUpdate
```

## Diagnóstico rápido

```powershell
Get-Item "$env:LOCALAPPDATA\nvim" | Format-List FullName,LinkType,Target
nvim --clean
nvim '+checkhealth' '+q'
```

- Se a junction estiver errada, remova-a com `nvim\windows\uninstall.ps1` e rode `install.ps1` novamente.
- Se um comando de linguagem não for encontrado, feche todos os terminais, abra um novo PowerShell e confirme `Get-Command <nome-do-comando>`.
- Se plugins falharem ao baixar, confirme que `git` está no `PATH` e rode `:Lazy sync`.
