# Visualização de Imagens no Yazi - Configuração Completa

## ✅ Configurações Aplicadas

### 1. Openers Configurados
O Yazi agora usa visualizadores especializados para imagens:
- `imv` - Visualizador minimalista para terminal (recomendado)
- `nsxiv` - Alternativa leve
- `feh` - Visualizador tradicional com suporte a tela cheia
- `xdg-open` - Fallback para navegador (Firefox)

### 2. Preview Otimizado
- **Resolução aumentada**: 1920x1080 (antes 600x900)
- **Filtro melhorado**: Lanczos3 (mais nítido)
- **Qualidade**: 90% (antes 75%)

### 3. Atalhos Configurados

| Atalho | Ação | Contexto |
|--------|------|----------|
| `Enter` | Abrir imagem em tela cheia | Arquivos de imagem |
| `E` | Abrir imagem em tela cheia | Arquivos de imagem |
| `l` | Smart Enter (entra na pasta ou abre imagem) | Sempre |
| `q` | Fechar visualização | Modo imagem |

## 🔧 Instalação Manual de Visualizadores

### Para Arch Linux/Manjaro:
```bash
sudo pacman -S imv
```

### Para Debian/Ubuntu:
```bash
sudo apt update
sudo apt install feh
```

### Para Fedora:
```bash
sudo dnf install feh
```

## 🎮 Como Usar

1. **Navegação normal**: Use as setas para mover entre arquivos
2. **Abrir imagem**: Pressione `Enter` ou `E` sobre um arquivo de imagem
3. **Navegar entre imagens**: Dentro do visualizador, use as setas
4. **Fechar**: Pressione `q` para voltar ao Yazi

## ⚙️ Configuração Adicional

Caso queira ajustar as configurações:

### Editar resolução do preview:
```toml
[preview]
max_width  = 1920  # Ajuste conforme sua tela
max_height = 1080  # Ajuste conforme sua tela
```

### Mudar visualizador padrão:
```toml
[image]
{ run = "imv %s", desc = "Open with imv", for = "unix", orphan = true },
```

## 🚀 Dicas Avançadas

1. **Modo apresentação**: Com `feh -F %s` as imagens abrem em tela cheia
2. **Background transparente**: `imv` suporta fundo transparente
3. **Controle de brilho**: `imv` permite ajuste de brilho com +/- 

A configuração está pronta! Execute `yazi` e teste com uma imagem. 📸