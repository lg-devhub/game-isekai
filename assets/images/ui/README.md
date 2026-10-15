# Diretório de Elementos de Interface (UI) — assets/images/ui/

Este diretório armazena molduras, botões, barras de rolagem, caixas de diálogo e painéis decorativos que compõem a identidade visual tátil de **Echoes of the Veil**.

---

## 1. Conteúdo Esperado
- Molduras estilizadas para caixas de diálogo (com textura de pergaminho antigo ou relevo de bronze solemniano).
- Texturas de botões de toque com estados: `normal`, `pressed`, `hover` e `disabled`.
- Sliders, marcadores de áudio e caixas de seleção (*checkboxes*).
- Texturas de 9 fatias (*NinePatchRect / StyleBoxTexture*) para painéis expansíveis.

## 2. Convenção de Nomenclatura
- Formato: `ui_[elemento]_[estado/variacao].png`
- Exemplos: `ui_button_primary_normal.png`, `ui_button_primary_pressed.png`, `ui_dialogue_panel_ninepatch.png`, `ui_slider_grabber.png`.

## 3. Formatos Preferidos e Otimização
- **Formato:** `.png` com canal alfa (32-bit).
- **Nine-Patch / 9 Fatias:** Painéis e caixas devem ser projetados com margens escaláveis (bordas fixas e miolo expansível) para que uma mesma imagem possa ser utilizada em caixas de diálogo de qualquer largura e altura.
- **Atlas de UI:** Na fase de polimento, os arquivos individuais de UI serão compilados em um atlas consolidado (`ui_atlas.png`) para minimizar draw calls da GPU.

## 4. Integração no Tema Godot 4.x
- Configurados no arquivo de tema global `resources/themes/default_theme.tres`.
- Garantem uniformidade visual e legibilidade estética em todas as telas.

## 5. Rastreamento
- Registre cada asset no [`ASSET-MANIFEST.md`](file:///c:/Users/ogust/Desktop/game-isekai/assets/ASSET-MANIFEST.md).
