# Diretório de Tipografias — assets/fonts/

Este diretório armazena os arquivos de fontes tipográficas que definem a identidade visual do texto, diálogos e inscrições de **Echoes of the Veil**.

---

## 1. Conteúdo Esperado
- Fonte com serifa solene para títulos, monumentos e nomes de capítulos (ex: estética clássica romana/lapidar).
- Fonte legível, moderna e sem serifa ou com serifa humanista para o corpo de texto de diálogos e descrições do códice, garantindo alta legibilidade em telas pequenas.
- Fonte cursiva ou manuscrita para as anotações do Diário de Deduções do protagonista.

## 2. Convenção de Nomenclatura
- Formato: `font_[estilo]_[peso].ttf` (ou `.otf`)
- Exemplos: `font_title_serif_bold.ttf`, `font_body_text_regular.ttf`, `font_body_text_bold.ttf`, `font_journal_script.ttf`.

## 3. Formatos Preferidos e Requisitos de Caracteres
- **Formatos:** `.ttf` (TrueType Font) ou `.otf` (OpenType Font).
- **Cobertura de Caracteres Obrigatória:**
  - Caracteres latinos completos com acentuação em português brasileiro (`á, à, â, ã, é, ê, í, ó, ô, õ, ú, ç, Á, À, Â, Ã, É, Ê, Í, Ó, Ô, Õ, Ú, Ç`).
  - Pontuação completa e numerais arábicos e romanos.
- **Configuração na Godot 4.x:**
  - Habilitar `MSDF` (*Multi-channel Signed Distance Field*) nas opções de importação da fonte, garantindo nitidez absoluta em qualquer escala de zoom sem borrões ou serrilhamento.

## 4. Licenciamento
- Apenas fontes com licença comercial permissiva (como SIL Open Font License — OFL ou fontes autorais) podem ser incluídas.
- Registre o nome da fonte, autor e licença no [`ASSET-MANIFEST.md`](file:///c:/Users/ogust/Desktop/game-isekai/assets/ASSET-MANIFEST.md).
