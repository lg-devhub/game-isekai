# Diretório de Efeitos Sonoros — assets/audio/sfx/

Este diretório armazena todos os efeitos sonoros pontuais (SFX) acionados por toques de interface, mecanismos de puzzles e reações táteis do jogo.

---

## 1. Conteúdo Esperado
- Efeitos sonoros de interface de usuário (toques, confirmações, abas, virada de página).
- Sons mecânicos táteis (engrenagens girando, alavancas de bronze, trancas de pedra, queda de água).
- Feedback de resolução de puzzles (jingle harmônico de acerto, clique surdo de erro).

## 2. Convenção de Nomenclatura
- Formato: `sfx_[categoria]_[acao]_[variacao].wav`
- Exemplos: `sfx_ui_tap.wav`, `sfx_ui_page_turn.wav`, `sfx_mech_gear_click.wav`, `sfx_puzzle_solved.wav`, `sfx_puzzle_error.wav`.

## 3. Formatos Preferidos
- **Formato:** `.wav` (PCM Linear sem compressão, 16-bit, 44.1 kHz ou 48 kHz).
- **Justificativa:** O formato `.wav` não possui atraso de descompressão (*zero latency*), garantindo que o som seja emitido no exato milissegundo do toque do jogador na tela do smartphone.
- **Duração:** Amostras ultra-curtas (de 0,1s a 2,5s).

## 4. Como o Recurso é Referenciado no Jogo
- `AudioManager.play_sfx("SFX_PUZZLE_SUCCESS")`, direcionado ao barramento `SFX`.
- O nó `AudioStreamPlayer` na Godot deve ter `max_polyphony` configurado para permitir toques rápidos repetidos sem cortar sons anteriores.

## 5. Regras para Evitar Duplicação
- Sons genéricos (como cliques de botão de madeira ou papel) devem ser reutilizados em toda a interface por meio de aliases no manifesto.
