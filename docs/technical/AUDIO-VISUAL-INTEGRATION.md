# AUDIO-VISUAL-INTEGRATION — Pipeline de Integração de Assets Audiovisuais

Este documento detalha a metodologia de organização, carregamento, resolução de dependências e integração dos recursos audiovisuais que serão fornecidos manualmente pelo usuário em fases posteriores de desenvolvimento.

---

## 1. Princípio do Desacoplamento de Assets e Fallbacks

Para permitir que o desenvolvimento de código, telas e lógica continue de forma independente da produção de arte final:

1. **Resolução Indireta via `AssetManager`:**
   - Cenas de interface e scripts nunca carregam caminhos literais como `"res://assets/images/characters/hero.png"`.
   - As cenas solicitam o recurso por seu identificador canônico registrado no manifesto:  
     `AssetManager.get_texture("CHAR_HERO_PORTRAIT_NEUTRAL")` ou  
     `AssetManager.play_sfx("SFX_PUZZLE_CLICK")`.
2. **Sistema de Placeholders Automáticos:**
   - Se o arquivo físico correspondente ainda não tiver sido copiado para o diretório de assets, o `AssetManager` retorna automaticamente um recurso procedural temporário:
     - *Texturas Ausentes:* Gera um `ImageTexture` de tamanho solicitado com padrão xadrez (cinza e magenta) e o nome do identificador em texto legível.
     - *Áudios Ausentes:* Emite um log de depuração no console (`AssetManager: SFX_CLICK não encontrado. Silenciando playback.`) sem lançar exceções fatais.

---

## 2. Formatos Recomendados e Especificações Técnicas

| Categoria de Asset | Formato Preferido | Resolução / Taxa de Amostragem | Justificativa Técnica na Godot 4.x |
| :--- | :--- | :--- | :--- |
| **Ilustrações de Cenário** | `.png` ou `.webp` (lossless) | $1080 \times 1920$ px (base vertical) | Rápida descompressão na GPU mobile; baixo consumo de VRAM. |
| **Retratos de Personagem** | `.png` (canal alfa 32-bit) | $512 \times 512$ px ou $720 \times 1280$ px | Permite sobreposição nítida em caixas de diálogo. |
| **Ícones de UI e Inventário** | `.png` (canal alfa 32-bit) | $128 \times 128$ px ou $256 \times 256$ px | Proporção perfeita para grids e listas com alta densidade de pixels (DPI). |
| **Trilhas Musicais (BGM)** | `.ogg` (Vorbis) | 44.1 kHz, 16-bit, estéreo (128-160 kbps) | Formato comprimido nativo com suporte perfeito a looping contínuo sem pausas. |
| **Sons de Ambiente (BGS)** | `.ogg` (Vorbis) | 44.1 kHz, 16-bit, estéreo (96-128 kbps) | Loops leves para chuva, vento em cavernas e ruídos de aqueduto. |
| **Efeitos Sonoros (SFX)** | `.wav` (PCM não comprimido) | 44.1 kHz ou 48 kHz, 16-bit, mono/estéreo | Latência zero de disparo no momento exato do toque ou clique mecânico. |
| **Fontes Tipográficas** | `.ttf` ou `.otf` | Vetorial com suporte completo a acentuação latina | Renderização dinâmica com suporte a MSDF (*Multi-channel Signed Distance Field*). |

---

## 3. O Fluxo de Integração Manual pelo Usuário

Quando o usuário desejar adicionar um novo asset ao projeto, o processo seguirá três passos simples:

```
[1. Colocar o arquivo na pasta correta de assets/]
                     │
                     ▼
[2. Registrar a entrada no arquivo assets/ASSET-MANIFEST.md]
                     │
                     ▼
[3. Testar a cena correspondente na Godot]
    O AssetManager substituirá o placeholder pela arte real automaticamente!
```

### Exemplo de Registro no Código (`AssetCatalog.gd`)
```gdscript
# Dicionário mestre gerenciado pelo AssetManager
const ASSET_REGISTRY: Dictionary = {
    "CHAR_HERO_PORTRAIT_NEUTRAL": "res://assets/images/characters/char_hero_portrait_neutral.png",
    "BGM_VAL_SERENA_DAY": "res://assets/audio/music/bgm_val_serena_day.ogg",
    "SFX_PUZZLE_SOLVED": "res://assets/audio/sfx/sfx_puzzle_solved.wav",
    "FONT_MAIN_TITLE": "res://assets/fonts/Cinzel-Regular.ttf"
}
```

---

## 4. Otimização de Texturas e Atlas de Sprites

1. **Import Settings na Godot 4.x:**
   - Para texturas de UI e retratos: `Compress Mode = VRAM Compressed` ou `Lossless` (para garantir linhas nítidas sem artefatos de compressão em textos e ícones).
   - Ativação de `Filter = Linear` ou `Nearest` dependendo do estilo visual estabelecido.
2. **Texturas em Atlas para UI:**
   - Elementos recorrentes de botões, molduras de caixas de diálogo e flechas de navegação serão combinados em um atlas único de textura (`ui_atlas.png`), reduzindo a quantidade de *Draw Calls* da GPU para menos de 15 por frame.
