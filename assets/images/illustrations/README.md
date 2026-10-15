# Diretório de Ilustrações Especiais — assets/images/illustrations/

Este diretório contém ilustrações estáticas em tela cheia que acompanham revelações dramáticas de lore, clímax de capítulos e mosaicos históricos antigos.

---

## 1. Conteúdo Esperado
- Cenas de corte narrativas (ex: o colapso do laboratório na Terra às 03:17, o despertar de Talos-4, a visão do Véu de Axiomas e a queima de livros pelos inquisidores).
- Mosaicos e afrescos em tela cheia que funcionam como puzzles visuais ou recompensas de codex.

## 2. Convenção de Nomenclatura
- Formato: `illu_[capitulo]_[tema].png`
- Exemplos: `illu_prologue_earth_collapse.png`, `illu_cap2_talos_awakening.png`, `illu_cap3_mnemona_siege.png`, `illu_cap4_prismatic_bridge.png`.

## 3. Formatos Preferidos e Resoluções
- **Formato:** `.png` ou `.webp` (lossless de alta qualidade).
- **Resolução:** $1080 \times 1920$ pixels (ou $1440 \times 2560$ pixels para telas de alta resolução).
- **Estilo:** Ilustração digital com estética de pintura clássica e gravura arcaica, em consonância com o tom sóbrio e contemplativo da direção de arte.

## 4. Integração no Jogo
- Exibidas através da cena `CutsceneImageViewer.tscn` com animações suaves de pan e zoom (*Ken Burns Effect*) via nó `AnimationPlayer` ou `Tween`.

## 5. Licenciamento e Registro
- Cada ilustração deve ser documentada no [`ASSET-MANIFEST.md`](file:///c:/Users/ogust/Desktop/game-isekai/assets/ASSET-MANIFEST.md).
