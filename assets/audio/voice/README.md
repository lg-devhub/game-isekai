# Diretório de Vozes e Reações — assets/audio/voice/

Este diretório destina-se a breves reações vocais (*voice grunts*, suspiros, exclamações) ou dublagens parciais de personagens.

---

## 1. Conteúdo Esperado
- Reações acústicas curtas dos personagens ao iniciar um diálogo ou ao cometer erros em puzzles (ex: o suspiro cansado de Vaelen, a tosse seca de Asma de Éter do protagonista, a risada sutil de Lyra).
- Não há dublagem de frases inteiras planejada para o escopo inicial; o foco é em reações diegéticas para dar textura dramática à leitura.

## 2. Convenção de Nomenclatura
- Formato: `vo_[personagem]_[emocao/reacao].ogg`
- Exemplos: `vo_hero_cough_asthma.ogg`, `vo_lyra_gasp.ogg`, `vo_talos_drone_activate.ogg`, `vo_malakor_sigh.ogg`.

## 3. Formatos Preferidos
- **Formato:** `.ogg` ou `.wav` mono (centralizado no canal estéreo).
- **Taxa de Amostragem:** 44.1 kHz, 16-bit.

## 4. Como o Recurso é Referenciado no Jogo
- Pelo nó `DialogueRunner` ao acionar um nó de diálogo específico com a tag `voice_clip: "VO_LYRA_GASP"`.

## 5. Rastreamento
- Registre cada ator, dublador voluntário ou sintetizador utilizado no [`ASSET-MANIFEST.md`](file:///c:/Users/ogust/Desktop/game-isekai/assets/ASSET-MANIFEST.md).
