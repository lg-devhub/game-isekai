# ARCHITECTURE — Arquitetura de Software e Padrões de Sistema (Godot 4.x)

Este documento especifica a arquitetura técnica global, os padrões de projeto, a estrutura de comunicação orientada a eventos e a hierarquia modular de nós e scripts de **Echoes of the Veil** na **Godot Engine 4.x**, integrando os requisitos do RPG educativo ([`LEARNING-DESIGN.md`](file:///c:/Users/ogust/Desktop/game-isekai/docs/game-design/LEARNING-DESIGN.md)) e a operação estritamente off-line.

> **Nota de Fase:** Este documento constitui o planejamento arquitetural mestre para guiar a implementação que terá início a partir da Fase 2 do Roadmap. Na presente Fase 1, o projeto mantém-se em documentação e estruturação de diretórios, sem código executável prematuro.

---

## 1. Visão Arquitetural em Camadas

A arquitetura adota uma separação rígida de responsabilidades em quatro camadas concêntricas, assegurando baixo acoplamento, facilidade de manutenção e 100% de operação local:

```
┌────────────────────────────────────────────────────────────────────────┐
│                      CAMADA DE APRESENTAÇÃO (UI)                       │
│    Cenas .tscn de Telas, Caixas de Diálogo, PuzzleViews e Controles    │
├────────────────────────────────────────────────────────────────────────┤
│                      CAMADA DE SERVIÇOS & GESTÃO                       │
│      Singletons Globais (Autoloads): GameManager, SceneManager,        │
│    SaveSystem, AudioManager, SettingsManager, CodiceManager, i18n      │
├────────────────────────────────────────────────────────────────────────┤
│                      CAMADA DE LÓGICA DE NEGÓCIO                       │
│    QuestManager, PuzzleEngine, ProgressionManager, EconomyManager,    │
│       InventoryManager, ForensicEngine, DialogueRunner, ReviewEngine   │
├────────────────────────────────────────────────────────────────────────┤
│                     CAMADA DE DADOS & PERSISTÊNCIA                     │
│      Arquivos JSON (Quests/Puzzles), Custom Resources (.tres),         │
│          Saves Locais com HMAC (user://saves/), Códice Offline         │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Padrões de Projeto e Comunicação

1. **Arquitetura Baseada em Sinais (*Signal-Driven*):**
   - Módulos nunca chamam métodos de nós pais diretamente. A comunicação ascendente é sempre realizada via `signal` nativo da Godot (ex: `signal puzzle_solved(puzzle_id, rewards)`).
   - A comunicação descendente é feita por chamadas de métodos diretos ou injeção de dependências.
2. **Separação de Conteúdo (*Content as Data*):**
   - Nenhum diálogo, enigma, preço de item ou descrição de quest reside hardcoded em código GDScript. Tudo é lido de arquivos `.json` ou instâncias de `Resource` (`.tres`).
3. **Padrão Strategy para Validadores Pedagógicos de Puzzles:**
   - O `PuzzleEngine` delega a verificação de respostas para quatro classes validadoras especializadas correspondentes às quatro grandes áreas do aprendizado:
     - `MathValidator`: Validação numérica com tolerância infinitesimal para arredondamentos.
     - `LogicValidator`: Validação de premissas, grafos e estados booleanos.
     - `LanguageValidator`: Normalização fonética/ortográfica, remoção de diacríticos e correspondência semântica.
     - `ScienceValidator`: Validação de unidades de medida físicas e respostas multidimensionais.
4. **Arquitetura 100% Off-line (*Zero-Backend Architecture*):**
   - Todos os dados, regras de validação, verbetes enciclopédicos do Códice e lógicas de gameplay residem no pacote local do aplicativo. É proibido qualquer acoplamento com APIs remotas, servidores de autenticação ou telemetria invasiva.

---

## 3. Especificação dos Singletons (Autoloads) Globais

Os seguintes nós são planejados para registro no `project.godot` para persistir durante a sessão de jogo:

| Nome do Autoload | Script GDScript Planejado | Responsabilidade Principal |
| :--- | :--- | :--- |
| **`GameManager`** | `scripts/core/game_manager.gd` | Orquestra o estado global do jogo (TELA_INICIAL, EXPLORACAO, DIALOGO, PUZZLE, CODICE, PAUSA). |
| **`SceneManager`** | `scripts/core/scene_manager.gd` | Gerencia transições suaves de tela com fade in/out e controle de memória assíncrono. |
| **`SaveSystem`** | `scripts/core/save_system.gd` | Serialização e desserialização atômica de saves locais, geração de backup e verificação HMAC. |
| **`SettingsManager`** | `scripts/core/settings_manager.gd` | Persiste opções de áudio, display, acessibilidade e idioma em `user://settings.cfg`. |
| **`AudioManager`** | `scripts/audio/audio_manager.gd` | Toca faixas de música, ambientes em loop e efeitos sonoros direcionados para os barramentos corretos. |
| **`QuestManager`** | `scripts/gameplay/quest_manager.gd` | Controla o estado de todas as quests (Não Iniciada, Ativa, Concluída) e seus objetivos pedagógicos. |
| **`PuzzleEngine`** | `scripts/puzzle/puzzle_engine.gd` | Carrega dados de enigmas de arquivos JSON, gerencia dicas graduais, valida soluções e emite feedback diagnóstico. |
| **`ProgressionManager`**| `scripts/gameplay/progression_manager.gd` | Rastreia Pontos de Erudição, níveis acadêmicos e árvores de habilidades. |
| **`CodiceManager`** | `scripts/gameplay/codice_manager.gd` | Gerencia o *Códice do Conhecimento*, desbloqueios de conceitos, exemplos resolvidos e revisões voluntárias. |
| **`EconomyManager`** | `scripts/gameplay/economy_manager.gd` | Gerencia saldo de Lúmis e Prismas de Sal, assegurando a regra ética de que conhecimento nunca é vendido. |
| **`InventoryManager`** | `scripts/gameplay/inventory_manager.gd` | Armazena itens coletados, reagentes botânicos e documentos forenses. |
| **`AssetManager`** | `scripts/core/asset_manager.gd` | Resolve caminhos de texturas, fontes e áudios com suporte a placeholders temporários para assets manuais. |

---

## 4. Estrutura Canônica de Diretórios do Projeto Godot

```text
game-isekai/
├── project.godot              # Arquivo de configuração mestre da Godot 4.x
├── export_presets.cfg         # Configurações de exportação para Android e iOS
│
├── scenes/                    # Árvores de nós visuais (.tscn)
│   ├── boot/                  # Splash screens e inicialização
│   ├── menus/                 # Tela inicial, configurações, créditos
│   ├── exploration/           # Telas de cenários com hotspots
│   ├── dialogue/              # Caixa de diálogo, balões e portraits
│   ├── puzzle/                # Tela mestre de puzzles e viewports interativos
│   ├── journal/               # Diário de deduções, mapa e Códice do Conhecimento
│   └── ui/                    # Componentes reutilizáveis (botões, barras de moedas)
│
├── scripts/                   # Lógica GDScript (.gd) — a ser criada na Fase 2
│   ├── core/                  # GameManager, SceneManager, SaveSystem, AssetManager
│   ├── gameplay/              # Quests, Progressão, Códice, Economia, Inventário
│   ├── puzzle/                # PuzzleEngine, Validadores Pedagógicos, Manipuladores
│   ├── dialogue/              # DialogueRunner, Parser de roteiros
│   └── audio/                 # AudioManager e controladores de barramento
│
├── resources/                 # Definições de tipos Custom Resource (.tres)
│   ├── themes/                # Godot Themes, estilos de botões, caixas de diálogo
│   ├── items/                 # Recursos de itens de inventário
│   └── cosmetics/             # Definições de roupas e penteados
│
├── data/                      # Arquivos puros de dados (.json)
│   ├── puzzles/               # Arquivos de puzzles com metadados pedagógicos
│   ├── quests/                # Definições de missões com objetivos de aprendizagem
│   ├── dialogues/             # Roteiros e ramificações de conversa por capítulo
│   └── codex/                 # Verbetes do Códice do Conhecimento e exercícios
│
└── assets/                    # Diretórios de assets audiovisuais externos (manuais)
```

---

## 5. Fluxo de Execução de um Desafio Pedagógico

```
[Hotspot / Evento Narrativo] 
        │
        ▼ emite sinal `request_puzzle(puzzle_id)`
[GameManager] 
        │ altera estado para `PUZZLE_ACTIVE`
        ▼
[SceneManager] 
        │ transiciona suavemente para `scenes/puzzle/PuzzleView.tscn`
        ▼
[PuzzleEngine] 
        │ lê `data/puzzles/{puzzle_id}.json`
        │ seleciona validador (Math, Logic, Language, Science)
        │ instancia componente de input apropriado
        ▼
[Jogador Submete Resposta]
        │
        ▼ chama `PuzzleEngine.validate_answer(user_input)`
[Validador Pedagógico]
        │
        ├── Se Incorreto:
        │        identifica padrão de erro (`common_errors`)
        │        emite `puzzle_feedback_diagnostic(diagnostic_text)`
        │        PuzzleView exibe explicação construtiva (sem punição)
        │
        └── Se Correto:
                emite `puzzle_solved(puzzle_id, rewards)`
                ├── SaveSystem salva progresso local atômico
                ├── ProgressionManager adiciona XP de Erudição
                ├── CodiceManager desbloqueia verbete com demonstração formal
                ├── EconomyManager credita Lúmis / Prismas
                ├── QuestManager avança a etapa da missão
                └── SceneManager retorna suavemente ao diálogo/exploração
```

---

## 6. Tratamento de Falhas e Robustez Mobile

1. **Carregamento Seguro de Recursos:** Todas as chamadas para `ResourceLoader.load()` ou parseamento JSON verificam se o arquivo existe via `FileAccess.file_exists()`. Caso um asset esteja ausente, o `AssetManager` injeta um recurso procedural provisório sem interromper a execução.
2. **Gerenciamento Eficiente de Memória:** Cenas de puzzles complexos e janelas do Códice são liberadas da memória (`queue_free()`) ao serem fechadas, assegurando que o consumo de memória RAM permaneça abaixo de 250 MB em qualquer smartphone.
