# Diretório de Sons de Ambiente — assets/audio/ambience/

Este diretório destina-se às paisagens sonoras contínuas (BGS — *Background Sounds*) que criam a textura sensorial dos cenários.

---

## 1. Conteúdo Esperado
- Gravações em loop contínuo de fenômenos climáticos e ambientes naturais/construídos: o murmúrio da água nos aquedutos, o vento seco sobre a sílica da cratera, o eco de gotas em cavernas e o zumbido de cristais ressonantes.

## 2. Convenção de Nomenclatura
- Formato: `bgs_[ambiente]_[variacao].ogg`
- Exemplos: `bgs_crater_wind.ogg`, `bgs_aqueduct_water.ogg`, `bgs_library_whispers.ogg`.

## 3. Formatos Preferidos
- **Formato:** `.ogg` (Ogg Vorbis) em loop sem interrupções.
- **Taxa de Amostragem:** 44.1 kHz, 16-bit, estéreo ou mono espacializado.
- **Bitrate:** 96 kbps a 128 kbps.

## 4. Como o Recurso é Referenciado no Jogo
- Pelo script `AudioManager.play_ambience("BGS_AQUEDUCT_WATER")` conectado diretamente ao barramento de áudio `Ambience` da Godot 4.x.

## 5. Regras de Qualidade e Licenciamento
- Ruídos de fundo devem ser limpos de artefatos de compressão ou cortes abruptos de volume (*crossfade* de 2 segundos no início/fim).
- Registre cada arquivo incorporado no [`ASSET-MANIFEST.md`](file:///c:/Users/ogust/Desktop/game-isekai/assets/ASSET-MANIFEST.md).
