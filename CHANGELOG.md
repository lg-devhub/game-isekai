# CHANGELOG — Echoes of the Veil

Todas as alterações relevantes de documentação, decisões de arquitetura e design de jogo são registradas neste arquivo.

O formato segue o padrão baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/).
Como o projeto está em fase de planejamento, os registros refletem marcos documentais e revisões conceituais, sem versões falsas de software executável.

---

## [Fase 3 — Sistemas Essenciais de Gameplay] - 2026-10-15

### Adicionado
- **Diário do Investigador e Inventário Forense Integrado (`JournalView.tscn` / `journal_view.gd`):**
  - Aba de Quests e Investigações: visualização de missões ativas e concluídas, contexto de lore, acompanhamento de estágios, checklist de objetivos investigativos com status dinâmico (`[✔] Concluído` / `[⏳] Pendente`), exibição de recompensas e atalho para resolução de enigmas vinculados.
  - Aba de Inventário e Evidências: gerenciamento de bolsa de itens (itens chave, consumíveis com uso e feedback imediato) e acervo de documentos forenses.
  - Sistema de Exame Pericial Interativo: lupa forense que permite inspecionar detalhes pontuais de documentos (`cabecalho`, `tabela_comparativa`, `nota_rodape`, `marca_dagua`) com feedback tátil e sonoro.
- **Integração de Quests e Recompensas Pedagógicas (`QuestManager`):**
  - Métodos utilitários de acesso público (`get_quest_definition`, `get_quest_objectives`, `get_all_quest_ids`).
  - Carregamento de dados a partir de `data/quests/` (`QP_PROLOGO_01.json`, `QP_PROLOGO_02.json`).
  - Resolução de enigmas via `PuzzleEngine` aciona automaticamente o avanço e conclusão de objetivos de missões investigativas.
- **Sistema de Progressão de Erudição (`ProgressionManager`):**
  - Limiares de XP progressivos até nível 15 e 15 títulos honoríficos de Erudito.
  - Acompanhamento de maestria nas quatro áreas essenciais: Matemática, Lógica, Linguagem e Ciências.
- **Menu de Configurações Completo (`SettingsView.tscn` / `settings_view.gd`):**
  - Ajustes de volume independentes para 5 barramentos (Master, Music, Ambience, SFX, UI).
  - Escala dinâmica de tipografia (Normal, Grande, Máximo) e opções de acessibilidade (modo daltonismo e redução de movimento).
  - Gerenciamento seguro de dados locais com confirmação dialogada contra perda acidental de saves.
- **Customização Estética do Viajante (`CustomizationView.tscn` / `customization_view.gd`):**
  - Escolha de tom de pele, cortes e cores de cabelo, e vestimentas diegéticas (Traje de Viajante, Erudito Aprendiz, Investigador).
  - Persistência das escolhas cosméticas no perfil do jogador em `SaveSystem`.
- **Navegação Global e Conectividade entre Telas:**
  - Botão de acesso ao Diário no `MainMenu.tscn`.
  - Botão de consulta rápida ao Diário integrado no cabeçalho do `PuzzleView.tscn`.
  - Retorno dinâmico e contextual de cena (`‹ Voltar`) respeitando a origem da chamada (Menu Principal ou Enigma em andamento).

---

## [Fase 2 — Protótipo Educativo & Vertical Slice] - 2026-10-15

### Adicionado
- **Configuração do Projeto Godot 4.x:**
  - Criação de `project.godot` (resolução portrait 1080x1920, stretch canvas_items, modo GL Compatibility para mobile 2D).
  - Criação de `default_bus_layout.tres` com 5 barramentos de áudio (Master, Music, Ambience, SFX, UI).
- **Arquitetura de Autoloads Globais (Core):**
  - `GameManager`: máquina de estados do ciclo de vida da aplicação.
  - `SceneManager`: transições suaves de cenas e controle assíncrono.
  - `SaveSystem`: persistência atômica local com backup fallback e verificação HMAC/SHA-256.
  - `SettingsManager`: gerenciamento de áudio e acessibilidade em `user://settings.cfg`.
  - `AssetManager`: resolução de texturas e áudios com suporte a placeholders procedurais.
  - `AudioManager`: roteamento para barramentos de som independentes.
  - `CodiceManager`: repositório off-line do Códice do Conhecimento com verbetes e exemplos.
  - `PuzzleEngine`: motor de quebra-cabeças com 4 validadores pedagógicos (`MathValidator`, `LogicValidator`, `LanguageValidator`, `ScienceValidator`).
- **Telas e Interface Gráfica Responsiva (Mobile 2D):**
  - `Boot.tscn`: tela de splash e carregamento inicial.
  - `MainMenu.tscn`: menu principal com acesso ao protótipo e ao Códice.
  - `PuzzleView.tscn`: tela mestre de desafios com badges de área, 3 níveis de dicas graduais, feedback diagnóstico sem punição, seletor de puzzles e overlay de vitória.
  - `CodiceView.tscn`: visualizador enciclopédico do Códice com navegação por abas (Matemática, Lógica, Linguagem, Ciências) e exemplos resolvidos.
- **Conteúdo de Dados Iniciais da Vertical Slice:**
  - Puzzles em JSON: `PUZ_MATH_001.json`, `PUZ_SCI_001.json`, `PUZ_LOG_001.json`, `PUZ_LANG_001.json`.
  - Verbetes do Códice em JSON: `COD_MATH_001.json`, `COD_SCI_001.json`, `COD_LOG_001.json`, `COD_LANG_001.json`.

---

## [Fase 1 — Consolidação Pedagógica e Operação Offline] - 2026-10-15

### Adicionado e Atualizado
- **Revisão Canônica de Identidade e Princípio Central:**
  - Definição do princípio mestre **"Educação acima de tudo"**: o jogo é formalmente classificado como um **RPG educativo narrativo de fantasia isekai**.
  - Definição oficial do público-alvo prioritário: **adolescentes de 12 a 17 anos**.
  - Criação do documento fundamental [`docs/game-design/LEARNING-DESIGN.md`](file:///c:/Users/ogust/Desktop/game-isekai/docs/game-design/LEARNING-DESIGN.md), detalhando matriz de competências, objetivos de aprendizagem, habilidades-alvo, conhecimentos prévios e os quatro momentos pedagógicos: *Descoberta*, *Prática Guiada*, *Aplicação Independente* e *Consolidação*.
  - Especificação detalhada do **Códice do Conhecimento**: sistema local acessível a qualquer momento com resumos, soluções comentadas, glossário e revisão espaçada offline.
- **Estruturação Curricular em 4 Áreas Equilibradas:**
  - *Matemática:* Proporções, álgebra, sequências, combinatória, geometria e otimização.
  - *Lógica e Pensamento Crítico:* Dedução, indução, causa-efeito, contradições e análise de falácias.
  - *Linguagem e Interpretação:* Interpretação em contexto, metáforas, ambiguidade, charadas e documentos.
  - *Ciências:* Método científico, física básica, astronomia, química introdutória e ecossistemas.
- **Decisão Definitiva de Conectividade:**
  - O jogo é **100% offline após a instalação**, sem requisitos de contas, autenticação remota, telemetria obrigatória ou dependência de servidores.
- **Reorganização do Roadmap:**
  - Reestruturação em **7 fases oficiais** (da Documentação até a Publicação e Validação Pedagógica).
- **Catálogo de Puzzles Pedagógicos:**
  - Atualização do catálogo de 60 puzzles com inclusão de habilidade-alvo, conhecimentos prévios, erros comuns, dicas graduais e transferência conceitual para novos contextos.

---

## [Fase 1 — Documentação Canônica Inicial] - 2026-10-15

### Adicionado
- Criação dos documentos de governança (`AGENTS.md`, `CONTEXT.md`, `README.md`, `GLOSSARY.md`).
- Criação dos documentos de Game Design em `docs/game-design/` (`GDD.md`, `CORE-LOOP.md`, etc.).
- Elaboração da Bíblia de Lore e Campanha em `docs/narrative/`.
- Estruturação técnica para Godot 4.x / GDScript em `docs/technical/`.
- Preparação dos diretórios de assets com READMEs e `ASSET-MANIFEST.md`.
