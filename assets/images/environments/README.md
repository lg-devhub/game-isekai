# Diretório de Cenários e Ambientes — assets/images/environments/

Este diretório armazena as ilustrações de fundo 2D (backgrounds) dos locais exploráveis de Velathys.

---

## 1. Conteúdo Esperado
- Ilustrações de cenários completos onde o jogador explora, lê diálogos e localiza pontos de interesse (*hotspots*).
- Regiões: A Cratera de Vidro Azul, o Mercado dos Oleiros de Val-Serena, o Interior do Arquivo Municipal, as Catacumbas de Solemnia, as Câmaras de Ark-Mnemona e o Templo dos Axiomas.

## 2. Convenção de Nomenclatura
- Formato: `bg_[regiao]_[local]_[variacao].png`
- Exemplos: `bg_crater_blue_glass.png`, `bg_val_serena_market_day.png`, `bg_solemnia_catacombs_crypt.png`, `bg_mnemona_grand_archive.png`.

## 3. Formatos Preferidos e Resoluções
- **Formato:** `.png` ou `.webp` (lossless de alta fidelidade).
- **Resolução de Base:** $1080 \times 1920$ pixels (orientação vertical Portrait 9:16).
- **Suporte a Telas Longas (19.5:9 / 20:9):** Recomenda-se que as ilustrações tenham $1080 \times 2400$ pixels, com a ação principal concentrada na área central de 1080x1920, permitindo que a imagem se estenda organicamente no topo e base em smartphones modernos sem repetição de textura.

## 4. Integração na Engine
- Renderizado através do nó mestre `TextureRect` ou `ParallaxBackground` na cena `ExplorationView.tscn`.
- Hotspots interativos (marcações de toque) utilizam posições relativas em coordenadas normalizadas (0.0 a 1.0) para se manterem exatamente sobre as portas e baús desenhados, independentemente do estiramento da tela.

## 5. Rastreamento e Manifesto
- Registre cada novo cenário no [`ASSET-MANIFEST.md`](file:///c:/Users/ogust/Desktop/game-isekai/assets/ASSET-MANIFEST.md).
