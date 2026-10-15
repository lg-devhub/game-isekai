# Diretrizes Gerais de Assets — Echoes of the Veil

> **AVISO IMPORTANTE:** Esta pasta foi estruturada exclusivamente para receber os arquivos audiovisuais reais que serão fornecidos manualmente pelo usuário em etapas posteriores. **Nenhum arquivo de imagem, áudio, vídeo ou fonte artificial foi gerado ou baixado nesta etapa.**

---

## 1. Estrutura de Diretórios de Assets

```text
assets/
├── README.md                  # Este documento de diretrizes gerais
├── ASSET-MANIFEST.md          # Registro central de todos os assets integrados
│
├── audio/                     # Arquivos sonoros
│   ├── music/                 # Trilhas musicais de fundo (BGM)
│   ├── ambience/              # Paisagens sonoras e ruídos de fundo (BGS)
│   ├── sfx/                   # Efeitos sonoros curtos de interface e mecânicas
│   └── voice/                 # Vozes e reações vocais pontuais
│
├── images/                    # Recursos visuais 2D estáticos
│   ├── characters/            # Sprites e retratos de personagens
│   ├── environments/          # Fundos de cenários e dioramas de exploração
│   ├── items/                 # Ilustrações detalhadas de itens examináveis
│   ├── icons/                 # Ícones de inventário e categorias
│   ├── ui/                    # Molduras, barras, botões e atlas de interface
│   └── illustrations/         # Cenas narrativas de corte e mosaicos
│
├── fonts/                     # Arquivos de tipografia (.ttf / .otf)
├── animation/                 # Dados de animação 2D e sequências de sprites
└── video/                     # Cutscenes e sequências pré-renderizadas
```

---

## 2. Princípios de Importação e Gerenciamento

1. **Registro Obrigatório no Manifesto:**
   - Sempre que um novo arquivo for colocado em uma das subpastas, adicione uma linha correspondente na tabela de [`ASSET-MANIFEST.md`](file:///c:/Users/ogust/Desktop/game-isekai/assets/ASSET-MANIFEST.md).
2. **Nomenclatura Estrita em `snake_case`:**
   - Nunca use espaços em branco, caracteres especiais ou acentuação em nomes de arquivos (use `bgm_val_serena.ogg` em vez de `BGM Val Serena 1!.ogg`).
3. **Evitar Arquivos Duplicados:**
   - Antes de adicionar uma nova imagem ou som, consulte o manifesto para verificar se já não existe um recurso equivalente ou genérico reutilizável.
4. **Respeito aos Direitos Autorais e Licenciamento:**
   - Apenas insira arquivos de sua autoria original ou recursos sob licenças abertas compatíveis com projetos autorais (ex: Creative Commons CC0, CC-BY com atribuição devida). Registre a licença no manifesto.
5. **Uso de Placeholders no Código:**
   - A Godot Engine está configurada para carregar texturas e sons via `AssetManager`. Se o arquivo real não existir, o sistema exibirá uma textura neutra de teste sem interromper a execução do jogo.
