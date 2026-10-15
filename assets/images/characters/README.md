# Diretório de Personagens — assets/images/characters/

Este diretório contém as artes 2D dos personagens de **Echoes of the Veil**, cobrindo retratos de diálogo (*portraits*), sprites de corpo inteiro para a tela de customização e camadas modulares (*paper doll*).

---

## 1. Conteúdo Esperado
- Retratos com expressões variadas (Neutro, Pensativo, Chocado, Determinado, Sorrindo).
- Camadas modulares de customização do protagonista (pele, olhos, cabelos, trajes e acessórios).
- Retratos e sprites de busto de coadjuvantes (Lyra, Talos-4, Mestre Vaelen, Inquisidor Malakor, Lady Cassia).

## 2. Convenção de Nomenclatura
- Retratos de Diálogo: `char_[nome]_[expressao].png`  
  Exemplos: `char_lyra_neutral.png`, `char_lyra_worried.png`, `char_malakor_cold.png`, `char_talos4_glow.png`.
- Componentes Modulares do Protagonista: `char_hero_[camada]_[variante].png`  
  Exemplos: `char_hero_body_skin2.png`, `char_hero_hair_braid_brown.png`, `char_hero_outfit_val_serena.png`.

## 3. Formatos Preferidos e Resoluções
- **Formato:** `.png` com transparência alfa (32-bit RGBA).
- **Dimensões Recomendadas:**
  - *Retratos de Diálogo:* $512 \times 512$ px (ou $768 \times 768$ px para telas 2K/Retina).
  - *Corpo Inteiro (Tela de Customização):* $720 \times 1280$ px.
- **Enquadramento:** Busto centralizado com linha dos olhos alinhada para evitar que a caixa de diálogo corte feições faciais importantes.

## 4. Integração na Godot 4.x
- Carregado através de nós `TextureRect` dentro de `DialogueBox.tscn` via:  
  `AssetManager.get_texture("CHAR_LYRA_PORTRAIT_NEUTRAL")`.
- Enquanto a arte definitiva não for fornecida, o jogo exibirá uma silhueta com gradiente neutro e o nome do personagem.

## 5. Diretrizes de Licenciamento
- Retratos devem ser obras autorais com cessão total de direitos de distribuição comercial para o projeto.
