# Diretório de Vídeos e Cutscenes — assets/video/

Este diretório destina-se a vídeos pré-renderizados, sequências de abertura cinemática ou introduções animadas de logotipo.

---

## 1. Conteúdo Esperado
- Vídeo de introdução do estúdio / apresentação do título.
- Cinemática de abertura mostrando a transposição da Terra às 03:17 da manhã (caso seja realizada em animação pré-renderizada em vez de cena em tempo real na engine).
- Animações dos encerramentos da campanha (Finais Alfa, Beta e Gama).

## 2. Convenção de Nomenclatura
- Formato: `video_[cena]_[resolucao].ogv` (ou `.webm` / `.mp4`)
- Exemplos: `video_intro_logo.ogv`, `video_prologue_cinematic.ogv`, `video_ending_prismatic_bridge.ogv`.

## 3. Formatos Preferidos e Otimização Mobile
- **Formato Nativo da Godot 4.x:** `.ogv` (Ogg Theora) ou `.webm` (VP8/VP9).
- **Resolução:** $1080 \times 1920$ pixels a 24 ou 30 quadros por segundo.
- **Taxa de Bits (Bitrate):** Máximo de 2.500 kbps a 3.500 kbps para evitar lentidão na leitura de armazenamento de celulares modestos.

## 4. Integração no Jogo
- Reproduzido pelo nó `VideoStreamPlayer` nativo da Godot.
- O script deve sempre oferecer um botão visível "Pular" (*Skip*) após 1,5 segundo de reprodução, respeitando o tempo do jogador mobile.

## 5. Licenciamento e Registro
- Todos os vídeos inseridos devem ser catalogados no [`ASSET-MANIFEST.md`](file:///c:/Users/ogust/Desktop/game-isekai/assets/ASSET-MANIFEST.md).
