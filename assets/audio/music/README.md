# Diretório de Músicas — assets/audio/music/

Este diretório é reservado para as faixas musicais de fundo (BGM — *Background Music*) de **Echoes of the Veil**.

---

## 1. Conteúdo Esperado
- Trilhas orquestrais, acústicas e contemplativas que estabelecem a atmosfera emocional das regiões e situações de jogo (exploração, suspense, momentos reflexivos e clímax).

## 2. Convenção de Nomenclatura
- Formato: `bgm_[regiao/situacao]_[variacao].ogg`
- Exemplos: `bgm_title_theme.ogg`, `bgm_val_serena_day.ogg`, `bgm_puzzle_contemplation.ogg`, `bgm_catacombs_echo.ogg`.

## 3. Formatos Preferidos
- **Formato:** `.ogg` (Ogg Vorbis) obrigatoriamente.
- **Taxa de Amostragem:** 44.1 kHz, 16-bit, estéreo.
- **Taxa de Bits (Bitrate):** 128 kbps a 160 kbps (ótimo balanço entre qualidade acústica e tamanho de arquivo mobile).
- **Looping:** Os arquivos devem ser preparados para *seamless loop* (looping contínuo sem estalos ou silêncios no final). Na Godot, marque a opção `Loop` nas propriedades de importação do arquivo.

## 4. Como o Recurso é Referenciado no Jogo
- Pelo identificador canônico no script:  
  `AudioManager.play_music("BGM_VAL_SERENA_DAY")`
- A rota é resolvida via [`assets/ASSET-MANIFEST.md`](file:///c:/Users/ogust/Desktop/game-isekai/assets/ASSET-MANIFEST.md).

## 5. Cuidados com Licenciamento e Duplicatas
- Evite inserir variações quase idênticas de uma mesma música. Para variações dinâmicas (ex: versão dia/noite), prefira faixas com camadas adicionais mixadas em tempo real.
- Assegure-se de que as composições sejam originais ou estejam sob licenças comerciais autorizadas sem royalties recorrentes.
