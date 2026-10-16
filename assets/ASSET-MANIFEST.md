# ASSET-MANIFEST — Manifesto de Rastreamento de Recursos Audiovisuais

Este documento registra formalmente todos os arquivos de imagem, áudio, vídeo e tipografia reais fornecidos pelo usuário e integrados ao projeto **Echoes of the Veil**.

---

## 1. Como Utilizar este Manifesto

Quando você adicionar um arquivo físico em qualquer subpasta de `assets/`, adicione uma linha na tabela correspondente preenchendo:
- **Identificador Canônico:** A chave única usada pelo código GDScript (ex: `BGM_TITLE_THEME`).
- **Caminho Relativo:** O local físico do arquivo dentro do projeto (ex: `assets/audio/music/bgm_title.ogg`).
- **Categoria:** `ÁUDIO`, `IMAGEM`, `FONTE`, `VÍDEO` ou `ANIMAÇÃO`.
- **Descrição / Uso:** A cena ou tela específica onde o recurso é utilizado.
- **Licença / Origem:** Autoral, CC-BY 4.0, Domínio Público, etc.
- **Status de Integração:** `PLANEJADO` (esperando arquivo), `PRESENTE` (arquivo na pasta), `INTEGRADO` (conectado no jogo).

---

## 2. Registro de Músicas e Ambientes (BGM / BGS)

| Identificador Canônico | Caminho Relativo | Categoria | Descrição / Uso | Licença / Origem | Status |
| :--- | :--- | :--- | :--- | :--- | :---: |
| `BGM_TITLE_THEME` | `assets/audio/music/bgm_title_theme.ogg` | Áudio (BGM) | Tema da tela inicial e menus principais | Fornecido pelo usuário | `INTEGRADO` |
| `BGM_PUZZLE_CONTEMPLATION`| `assets/audio/music/bgm_puzzle_contemplation.ogg`| Áudio (BGM) | Foco reflexivo durante telas de puzzle e Códice | Fornecido pelo usuário | `INTEGRADO` |
| `BGM_CRATER_MYSTERY` | `assets/audio/music/bgm_crater_mystery.ogg` | Áudio (BGM) | Exploração da Cratera de Vidro Azul | Fornecido pelo usuário | `INTEGRADO` |
| `BGM_VAL_SERENA_DAY` | `assets/audio/music/bgm_val_serena_day.ogg` | Áudio (BGM) | Cidade de Val-Serena e Bazar dos Eruditos | Fornecido pelo usuário | `INTEGRADO` |
| `BGM_CATACOMBS_ECHO` | `assets/audio/music/bgm_catacombs_echo.ogg` | Áudio (BGM) | Galerias subterrâneas de Solemnia | Fornecido pelo usuário | `INTEGRADO` |
| `BGM_CLIMAX_AXIOMS` | `assets/audio/music/bgm_climax_axioms.ogg` | Áudio (BGM) | Clímax no Observatório do Véu | Fornecido pelo usuário | `INTEGRADO` |
| `BGM_MNEMONA_SCHOLARS`| `assets/audio/music/bgm_mnemona_scholars.ogg`| Áudio (BGM) | Arquivo histórico e Grande Biblioteca | Fornecido pelo usuário | `INTEGRADO` |
| `BGS_CRATER_WIND` | `assets/audio/ambience/bgs_crater_wind.ogg` | Áudio (BGS) | Vento seco sobre rocha vitrificada da cratera | Fornecido pelo usuário | `INTEGRADO` |

---

## 3. Registro de Efeitos Sonoros (SFX)

| Identificador Canônico | Caminho Relativo | Categoria | Descrição / Uso | Licença / Origem | Status |
| :--- | :--- | :--- | :--- | :--- | :---: |
| `SFX_UI_TAP` | `assets/audio/sfx/sfx_ui_tap.wav` | Áudio (SFX) | Toque padrão em botões da interface móvel | Fornecido pelo usuário | `INTEGRADO` |
| `SFX_PAGE_TURN` | `assets/audio/sfx/sfx_page_turn.wav` | Áudio (SFX) | Virar página do Diário e desbloqueio de dicas | Fornecido pelo usuário | `INTEGRADO` |
| `SFX_GEAR_CLICK` | `assets/audio/sfx/sfx_gear_click.wav` | Áudio (SFX) | Compra na loja e engrenagens de enigmas | Fornecido pelo usuário | `INTEGRADO` |
| `SFX_PUZZLE_SUCCESS` | `assets/audio/sfx/sfx_puzzle_success.wav` | Áudio (SFX) | Solução correta confirmada | Fornecido pelo usuário | `INTEGRADO` |
| `SFX_PUZZLE_ERROR` | `assets/audio/sfx/sfx_puzzle_error.wav` | Áudio (SFX) | Tentativa incorreta de resposta | Fornecido pelo usuário | `INTEGRADO` |

---

## 4. Registro de Imagens e Personagens

| Identificador Canônico | Caminho Relativo | Categoria | Descrição / Uso | Licença / Origem | Status |
| :--- | :--- | :--- | :--- | :--- | :---: |
| `CHAR_HERO_PORTRAIT_NEUTRAL` | `assets/images/characters/char_hero_portrait_neutral.png` | Imagem (Retrato) | Retrato neutro do protagonista nas caixas de diálogo | Fornecido pelo usuário | `INTEGRADO` |
| `CHAR_LYRA_PORTRAIT_NEUTRAL` | `assets/images/characters/char_lyra_portrait_neutral.png` | Imagem (Retrato) | Retrato neutro da pesquisadora Lyra | Fornecido pelo usuário | `INTEGRADO` |
| `CHAR_LYRA_PORTRAIT_THINKING`| `assets/images/characters/char_lyra_portrait_thinking.png`| Imagem (Retrato) | Retrato reflexivo de Lyra durante análises | Fornecido pelo usuário | `INTEGRADO` |
| `CHAR_MALAKOR_PORTRAIT` | `assets/images/characters/char_malakor_portrait.png` | Imagem (Retrato) | Retrato de diálogo do diplomata Malakor | Fornecido pelo usuário | `INTEGRADO` |
| `CHAR_TALOS4_PORTRAIT` | `assets/images/characters/char_talos4_portrait.png` | Imagem (Retrato) | Retrato de diálogo do golem arcanista Talos-4 | Fornecido pelo usuário | `INTEGRADO` |
| `CHAR_VAELEN_PORTRAIT` | `assets/images/characters/char_vaelen_portrait.png` | Imagem (Retrato) | Retrato de diálogo do arquivista Vaelen | Fornecido pelo usuário | `INTEGRADO` |

---

## 5. Registro de Cenários e Fundos (Environments)

| Identificador Canônico | Caminho Relativo | Categoria | Descrição / Uso | Licença / Origem | Status |
| :--- | :--- | :--- | :--- | :--- | :---: |
| `BG_TITLE_SCREEN` | `assets/images/environments/bg_title_screen.png` | Imagem (Fundo) | Tela de abertura e menu inicial | Fornecido pelo usuário | `INTEGRADO` |
| `BG_BLUE_GLASS_CRATER` | `assets/images/environments/bg_blue_glass_crater.png` | Imagem (Fundo) | Fundo do Diário e região da Cratera | Fornecido pelo usuário | `INTEGRADO` |
| `BG_PUZZLE_DESK` | `assets/images/environments/bg_puzzle_desk.png` | Imagem (Fundo) | Mesa de estudo e resolução de enigmas | Fornecido pelo usuário | `INTEGRADO` |
| `BG_VAL_SERENA_MARKET` | `assets/images/environments/bg_val_serena_market.png` | Imagem (Fundo) | Mercado de Val-Serena e Bazar dos Eruditos | Fornecido pelo usuário | `INTEGRADO` |
| `BG_MNEMONA_LIBRARY` | `assets/images/environments/bg_mnemona_library.png` | Imagem (Fundo) | Grande Biblioteca de Ark-Mnemona e Códice | Fornecido pelo usuário | `INTEGRADO` |
| `BG_SOLEMNIA_CATACOMBS`| `assets/images/environments/bg_solemnia_catacombs.png`| Imagem (Fundo) | Catacumbas subterrâneas e tela de Configurações | Fornecido pelo usuário | `INTEGRADO` |
| `BG_AXIOMS_TEMPLE` | `assets/images/environments/bg_axioms_temple.png` | Imagem (Fundo) | Templo dos Três Axiomas e tela de Personalização | Fornecido pelo usuário | `INTEGRADO` |

---

## 6. Registro de Ícones Diegéticos

| Identificador Canônico | Caminho Relativo | Categoria | Descrição / Uso | Licença / Origem | Status |
| :--- | :--- | :--- | :--- | :--- | :---: |
| `ICON_CODEX_BOOK` | `assets/images/icons/icon_codex_book.png` | Imagem (Ícone) | Ícone representativo do Códice | Fornecido pelo usuário | `INTEGRADO` |
| `ICON_HERB_ANIS` | `assets/images/icons/icon_herb_anis.png` | Imagem (Ícone) | Ícone da folha de anis medicinal | Fornecido pelo usuário | `INTEGRADO` |
| `ICON_LUMI_COIN` | `assets/images/icons/icon_lumi_coin.png` | Imagem (Ícone) | Moeda Lúmis no cabeçalho e na loja | Fornecido pelo usuário | `INTEGRADO` |
| `ICON_SALT_PRISM` | `assets/images/icons/icon_salt_prism.png` | Imagem (Ícone) | Prisma de sal mineral | Fornecido pelo usuário | `INTEGRADO` |

---

## 7. Registro de Fontes Tipográficas

| Identificador Canônico | Caminho Relativo | Categoria | Descrição / Uso | Licença / Origem | Status |
| :--- | :--- | :--- | :--- | :--- | :---: |
| `FONT_BODY_TEXT` | `assets/fonts/font_body_text.otf` | Fonte | Tipografia principal (GUI padrão e diálogos com acentuação pt-BR) | Fornecido pelo usuário | `INTEGRADO` |
| `FONT_TITLE_SERIF` | `assets/fonts/font_title_serif.otf` | Fonte | Títulos estilizados e inscrições monumentais | Fornecido pelo usuário | `INTEGRADO` |
