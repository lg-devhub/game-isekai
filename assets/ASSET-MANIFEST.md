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
| `BGM_TITLE_THEME` | `assets/audio/music/bgm_title_theme.ogg` | Áudio (BGM) | Tema da tela inicial e menus principais | A definir pelo usuário | `PLANEJADO` |
| `BGM_CRATER_MYSTERY` | `assets/audio/music/bgm_crater_mystery.ogg` | Áudio (BGM) | Exploração da Cratera de Vidro Azul | A definir pelo usuário | `PLANEJADO` |
| `BGM_VAL_SERENA_DAY` | `assets/audio/music/bgm_val_serena_day.ogg` | Áudio (BGM) | Cidade de Val-Serena durante o dia | A definir pelo usuário | `PLANEJADO` |
| `BGM_CATACOMBS_ECHO` | `assets/audio/music/bgm_catacombs_echo.ogg` | Áudio (BGM) | Galerias subterrâneas de Solemnia | A definir pelo usuário | `PLANEJADO` |
| `BGM_PUZZLE_CONTEMPLATION`| `assets/audio/music/bgm_puzzle_contemplation.ogg`| Áudio (BGM) | Foco reflexivo durante telas de puzzle | A definir pelo usuário | `PLANEJADO` |
| `BGS_CRATER_WIND` | `assets/audio/ambience/bgs_crater_wind.ogg` | Áudio (BGS) | Vento seco sobre rocha vitrificada | A definir pelo usuário | `PLANEJADO` |
| `BGS_AQUEDUCT_WATER` | `assets/audio/ambience/bgs_aqueduct_water.ogg` | Áudio (BGS) | Som constante de água corrente em arcos | A definir pelo usuário | `PLANEJADO` |

---

## 3. Registro de Efeitos Sonoros (SFX)

| Identificador Canônico | Caminho Relativo | Categoria | Descrição / Uso | Licença / Origem | Status |
| :--- | :--- | :--- | :--- | :--- | :---: |
| `SFX_UI_TAP` | `assets/audio/sfx/sfx_ui_tap.wav` | Áudio (SFX) | Toque padrão em botões da interface | A definir pelo usuário | `PLANEJADO` |
| `SFX_PAGE_TURN` | `assets/audio/sfx/sfx_page_turn.wav` | Áudio (SFX) | Virar página do Diário de Deduções | A definir pelo usuário | `PLANEJADO` |
| `SFX_GEAR_CLICK` | `assets/audio/sfx/sfx_gear_click.wav` | Áudio (SFX) | Encaixe mecânico de dente de engrenagem | A definir pelo usuário | `PLANEJADO` |
| `SFX_PUZZLE_SUCCESS` | `assets/audio/sfx/sfx_puzzle_success.wav` | Áudio (SFX) | Solução correta confirmada | A definir pelo usuário | `PLANEJADO` |
| `SFX_PUZZLE_ERROR` | `assets/audio/sfx/sfx_puzzle_error.wav` | Áudio (SFX) | Tentativa incorreta de resposta | A definir pelo usuário | `PLANEJADO` |
| `SFX_COINS_RECEIVE` | `assets/audio/sfx/sfx_coins_receive.wav` | Áudio (SFX) | Crédito de Lúmis ao concluir quest | A definir pelo usuário | `PLANEJADO` |

---

## 4. Registro de Imagens e Personagens

| Identificador Canônico | Caminho Relativo | Categoria | Descrição / Uso | Licença / Origem | Status |
| :--- | :--- | :--- | :--- | :--- | :---: |
| `CHAR_HERO_BASE_M` | `assets/images/characters/char_hero_base_m.png` | Imagem | Base corporal masculina do protagonista | A definir pelo usuário | `PLANEJADO` |
| `CHAR_HERO_BASE_F` | `assets/images/characters/char_hero_base_f.png` | Imagem | Base corporal feminina do protagonista | A definir pelo usuário | `PLANEJADO` |
| `CHAR_LYRA_PORTRAIT_NEUTRAL`| `assets/images/characters/char_lyra_portrait_neutral.png`| Imagem | Retrato de diálogo de Lyra Vance | A definir pelo usuário | `PLANEJADO` |
| `CHAR_TALOS4_PORTRAIT` | `assets/images/characters/char_talos4_portrait.png` | Imagem | Retrato de diálogo de Talos-4 | A definir pelo usuário | `PLANEJADO` |
| `CHAR_MALAKOR_PORTRAIT` | `assets/images/characters/char_malakor_portrait.png` | Imagem | Retrato de diálogo de Malakor | A definir pelo usuário | `PLANEJADO` |

---

## 5. Registro de Cenários e Fundos (Environments)

| Identificador Canônico | Caminho Relativo | Categoria | Descrição / Uso | Licença / Origem | Status |
| :--- | :--- | :--- | :--- | :--- | :---: |
| `BG_BLUE_GLASS_CRATER` | `assets/images/environments/bg_blue_glass_crater.png` | Imagem | Fundo 2D da Cratera de Vidro Azul | A definir pelo usuário | `PLANEJADO` |
| `BG_VAL_SERENA_MARKET` | `assets/images/environments/bg_val_serena_market.png` | Imagem | Mercado de Val-Serena com aquedutos | A definir pelo usuário | `PLANEJADO` |
| `BG_SOLEMNIA_CATACOMBS`| `assets/images/environments/bg_solemnia_catacombs.png`| Imagem | Cripta subterrânea de alabastro | A definir pelo usuário | `PLANEJADO` |
| `BG_MNEMONA_LIBRARY` | `assets/images/environments/bg_mnemona_library.png` | Imagem | Grande arquivo de Ark-Mnemona | A definir pelo usuário | `PLANEJADO` |

---

## 6. Registro de Fontes Tipográficas

| Identificador Canônico | Caminho Relativo | Categoria | Descrição / Uso | Licença / Origem | Status |
| :--- | :--- | :--- | :--- | :--- | :---: |
| `FONT_TITLE_SERIF` | `assets/fonts/font_title_serif.ttf` | Fonte | Títulos arcaicos, inscrições de pedra | A definir pelo usuário | `PLANEJADO` |
| `FONT_BODY_TEXT` | `assets/fonts/font_body_text.ttf` | Fonte | Textos de diálogo e descrições do códice | A definir pelo usuário | `PLANEJADO` |
| `FONT_JOURNAL_SCRIPT` | `assets/fonts/font_journal_script.ttf` | Fonte | Caligrafia manual do Diário de Deduções | A definir pelo usuário | `PLANEJADO` |
