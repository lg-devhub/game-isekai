# Diretório de Itens Examináveis — assets/images/items/

Este diretório contém ilustrações de alta definição de objetos, documentos históricos, medalhões e frascos que podem ser inspecionados em detalhe no modo forense.

---

## 1. Conteúdo Esperado
- Imagens de itens que o jogador pode girar, ampliar e examinar em busca de pistas: o *Núcleo Áfono*, o mandado de prisão de Renard, a pena de ferro quebrada, o astrolábio paleolítico e medalhões da Primeira Aurora.

## 2. Convenção de Nomenclatura
- Formato: `item_inspect_[nome_do_item].png`
- Exemplos: `item_inspect_aphonic_core.png`, `item_inspect_broken_iron_pen.png`, `item_inspect_quarantine_astrolabe.png`.

## 3. Formatos Preferidos
- **Formato:** `.png` com canal alfa (32-bit RGBA).
- **Resolução:** $1024 \times 1024$ pixels. A alta resolução é essencial para que o jogador possa aplicar zoom forense de até 3x sem perda de nitidez em inscrições diminutas.

## 4. Integração no Jogo
- Utilizado na cena `ForensicInspector.tscn`. O script permite translação e rotação com gestos de pinça e arrasto na tela touchscreen.
- Pontos de interesse forenses (*forensic hotspots*) são definidos no arquivo de dados do item (`data/items/item_id.json`).

## 5. Licenciamento
- Registre cada asset no [`ASSET-MANIFEST.md`](file:///c:/Users/ogust/Desktop/game-isekai/assets/ASSET-MANIFEST.md).
