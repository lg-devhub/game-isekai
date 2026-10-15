# Diretório de Animações 2D — assets/animation/

Este diretório contém folhas de sprites (*spritesheets*), dados de esqueletos 2D ou arquivos vetoriais para animações de elementos interativos e efeitos especiais.

---

## 1. Conteúdo Esperado
- Animações de mecanismos de puzzles (giro contínuo de engrenagens, queda de pinos, fluxo de água em canos).
- Efeitos visuais de refração mágica da *Sensibilidade Prismática* e partículas de sal.
- Pequenas animações de repouso (*idle animations*) de personagens ou autômatos em diálogos.

## 2. Convenção de Nomenclatura
- Formato: `anim_[objeto/efeito]_[acao]_[fps]fps.png` (ou `.json` para dados de animação).
- Exemplos: `anim_gear_rotation_24fps.png`, `anim_prismatic_shimmer.png`, `anim_talos_eye_pulse.png`.

## 3. Formatos Preferidos
- Folhas de sprites (*Spritesheets*) em `.png` com grade regular (ex: $128 \times 128$ px por quadro) acompanhadas ou não de metadados JSON.
- Animações procedurais criadas nativamente dentro da Godot através de nós `AnimationPlayer` e `Tween` são sempre preferidas em relação a spritesheets pesados, pois economizam memória RAM mobile.

## 4. Integração na Engine
- Utilizado por nós `AnimatedSprite2D`, `GPUParticles2D` e `AnimationPlayer`.
- Registre cada asset no [`ASSET-MANIFEST.md`](file:///c:/Users/ogust/Desktop/game-isekai/assets/ASSET-MANIFEST.md).
