# Diretório de Ícones — assets/images/icons/

Este diretório contém pequenos símbolos gráficos utilizados na interface do usuário, listas de inventário, categorias de puzzles e notificações.

---

## 1. Conteúdo Esperado
- Ícones de itens de inventário (poções, pergaminhos, chaves, moedas).
- Ícones de categorias de puzzles (Compasso/Ábaco para LM, Lupa para OI, Balança para DL, Livro para CL, Engrenagem para EM, Máscara para NS).
- Símbolos de estado (Check de sucesso, Cruz de erro, Cadeado de bloqueio, Ponto de exclamação de quest ativa).

## 2. Convenção de Nomenclatura
- Formato: `icon_[categoria]_[nome].png`
- Exemplos: `icon_cat_math.png`, `icon_cat_deduction.png`, `icon_item_tisana.png`, `icon_currency_lumi.png`, `icon_currency_salt_prism.png`.

## 3. Formatos Preferidos
- **Formato:** `.png` com transparência (32-bit RGBA).
- **Dimensões:** $128 \times 128$ px (ou $256 \times 256$ px para suporte a telas de altíssima densidade).
- **Silhueta e Contraste:** Ícones devem possuir silhuetas claras e legíveis mesmo quando reduzidos a 32x32 pixels na tela do celular.

## 4. Integração no Jogo
- Referenciados em nós `TextureRect`, botões `Button` com textura e nas células de grade do `InventoryGrid.tscn`.
- Resolução via `AssetManager.get_icon("ICON_CURRENCY_LUMI")`.

## 5. Rastreamento
- Todos os ícones devem constar no [`ASSET-MANIFEST.md`](file:///c:/Users/ogust/Desktop/game-isekai/assets/ASSET-MANIFEST.md).
