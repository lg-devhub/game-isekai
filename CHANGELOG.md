# CHANGELOG — Echoes of the Veil

Todas as alterações relevantes de documentação, decisões de arquitetura e design de jogo são registradas neste arquivo.

O formato segue o padrão baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/).
Como o projeto está em fase de planejamento, os registros refletem marcos documentais e revisões conceituais, sem versões falsas de software executável.

---

## [Revisão Completa de Enigmas, Aprendizagem, Narrativa e Áudio] - 2026-10-16

### Adicionado e Aprimorado
- **Auditoria e Reestruturação Integral dos Enigmas (`data/puzzles/`):**
  - Auditoria dos 60 arquivos JSON do catálogo educativo: eliminação completa de campos vazios de instrução (`prompt: ""`), garantindo que todo enigma informe com precisão a tarefa a ser executada.
  - Implementação do modelo de referência da Investigação 1 (`PUZ_MATH_001` - Tisana Botânica):
    - Tabela visual diegética com a receita base (1 dose: 4 folhas de anis, 6 gotas de óleo de linho) vs objetivo (3 doses).
    - Suporte a formulário `MULTI_FIELD` com campos identificados e rotulados individualmente: "Quantidade de folhas de anis" e "Quantidade de gotas de óleo de linho".
    - Botão de ação contextualizado: "Preparar Infusão 🌿".
  - Enriquecimento dos enigmas de Ciências (`PUZ_SCI_001`), Lógica (`PUZ_LOG_001`, `PUZ_LOG_002`) e Linguagem (`PUZ_LANG_001`, `PUZ_LANG_002`) com painéis visuais de dados (`PanelVisualData`), tabelas, listas de regras e fragmentos de documentos antigos com tipografia serifada.
  - Atribuição de textos de botões de ação dinâmicos e temáticos para todos os enigmas ("Acionar Alavanca ⚙️", "Validar Hipótese 🔍", "Conferir Manifesto 📜", etc.).
- **Diagnósticos Pedagógicos Granulares e Construtivos nos Validadores:**
  - `MathValidator`: diagnóstico parcial inteligente para cálculo de proporções (reconhece acertos isolados de um ingrediente e identifica erro clássico de adição `+3` orientando para a multiplicação `×3`).
  - `ScienceValidator`: suporte a `MULTI_FIELD` e explicações físicas claras sobre vantagens mecânicas e leis da dinâmica sem jargões desnecessários.
  - `LogicValidator`: análise diagnóstica orientada pelas premissas e pistas documentais numeradas.
  - `LanguageValidator`: normalização ortográfica avançada, detecção de correspondência documental direta e prevenção de equívocos entre dados textuais e evidências físicas.
- **Sistema de Dicas Sequenciais e Economia Justa de Lúmis:**
  - Reformulação do `PuzzleEngine.request_hint()`: garantia de que a Dica 1 seja sempre gratuita (0 Lúmis).
  - Bloqueio estrito de acesso antecipado: o jogador é orientado a desbloquear a Dica 2 antes da Dica 3.
  - Verificação de saldo de Lúmis antes do débito, impedindo saldos negativos.
  - Dicas já adquiridas permanecem permanentemente acessíveis sem cobrança cumulativa ou recobra.
- **Áudio Contínuo e Não Interrompido (`AudioManager`):**
  - Configuração de propriedade de repetição (`stream.loop = true`) e conexão aos sinais `finished` de BGM e ambiência, erradicando silêncios súbitos durante longas sessões de reflexão investigativa.
  - Preservação da faixa em execução entre cenas compartilhadas através de `_current_bgm_key`.
- **Garantia de Integridade e Arquitetura Offline:**
  - `SaveSystem`: inicialização automática de perfil padrão em `_ready()` e aprimoramento das operações atômicas de salvamento com caminhos canônicos (`dir.copy`, `dir.rename`).
  - Bateria de testes automatizada executada e aprovada com 100% de sucesso nas 12 cenas do Godot 4.7.2 headless.

---

## [Revisão Prioritária de UI/UX, Personagens e Gameplay] - 2026-10-16

### Adicionado
- **Presença Visual de Personagens e Resolução da Invisibilidade:**
  - Diagnóstico da causa-raiz da ausência de personagens: as texturas de retratos (`char_hero_portrait_neutral`, `char_lyra_portrait_*`, etc.) não estavam sendo exibidas devido a chaves de preview inexistentes na tela de customização e à ausência de instanciamento do `DialogueBox` nas telas ativas.
  - `customization_view.gd` atualizado para carregar diretamente o retrato oficial `CHAR_HERO_PORTRAIT_NEUTRAL` com modulação de tom de pele em tempo real.
  - `PuzzleView.tscn` e `puzzle_view.gd` aprimorados com o painel do Companheiro/Mentor: exibição visual do retrato do personagem (Lyra, Vaelen, Talos-IV), alternando expressões dinamicamente (pensativa para dicas/erros diagnósticos, neutra/confiante para início e vitórias).
- **Tema Visual de RPG de Fantasia e Tipografia Global (`assets/theme/echoes_theme.tres`):**
  - Criação do tema centralizado do Godot 4.x com bordas douradas, painéis de ardósia translúcidos e botões ergonômicos adaptados para toque mobile.
  - Vinculação de `font_body_text.otf` e `font_title_serif.otf` no tema e definição no `project.godot` como tema customizado padrão para todas as cenas.
- **Reorganização do Fluxo Inicial e Telas de Aventura:**
  - Botão da tela inicial renomeado para "Iniciar Jogo", com detecção e exibição automática do botão "Continuar Jornada" caso haja progresso salvo.
  - Implementação da tela de **Seleção de Dificuldade** (`DifficultySelectView.tscn` / `difficulty_select.gd`) com 5 níveis pedagógicos detalhados e persistência via `SaveSystem`.
  - Implementação da tela de **Introdução Narrativa** (`NarrativeIntroView.tscn` / `narrative_intro.gd`), ambientada na Cratera do Vidro Azul com diálogo interativo com Lyra antes de iniciar a primeira investigação.
  - Criação do **Mapa de Expedições** (`QuestMapView.tscn` / `quest_map_view.gd`) com estados visuais claros (Concluída, Disponível, Em Progresso, Bloqueada), cartões detalhados com sinopse, lore, áreas educacionais e recompensas.
- **Experiência Investigativa nos Puzzles:**
  - Exibição de contexto de história e habilidade investigativa em vez de perguntas descontextualizadas de formulário.
  - Suporte à exibição da explicação passo a passo completa na tela de vitória com atalho para o Mapa de Expedições e Códice.
  - Feedback diagnóstico respeitoso em caso de respostas incorretas, acompanhado de orientações do mentor.
- **Aprimoramento do Motor de Áudio (`AudioManager`):**
  - Gerenciamento de trilha por chave canônica impedindo reinícios desnecessários ao trocar entre cenas com a mesma faixa.
  - Controle independente de música, ambiências (`stop_ambience`), efeitos sonoros táteis e toques de UI.

---

## [Fase 5 — Integração Audiovisual dos Assets Manuais] - 2026-10-16

### Adicionado
- **Catalogação e Integração no Manifesto Geral (`assets/ASSET-MANIFEST.md`):**
  - Registro de 33 arquivos audiovisuais e tipográficos físicos fornecidos e integrados com status `INTEGRADO`.
  - 8 faixas musicais e ambiências em formato `.ogg` de alta fidelidade e baixo consumo de memória.
  - 5 efeitos sonoros `.wav` táteis cobrindo toques de UI, viradas de página do diário, cliques de engrenagem e sons de vitória/erro em enigmas.
  - 6 retratos de personagens em alta resolução (`char_hero_portrait_neutral`, `char_lyra_portrait_neutral`, `char_lyra_portrait_thinking`, `char_malakor`, `char_talos4`, `char_vaelen`).
  - 7 ilustrações de cenários e fundos de tela em modo retrato (`bg_title_screen`, `bg_blue_glass_crater`, `bg_puzzle_desk`, `bg_val_serena_market`, `bg_mnemona_library`, `bg_solemnia_catacombs`, `bg_axioms_temple`).
  - 4 ícones temáticos diegéticos (`icon_codex_book`, `icon_herb_anis`, `icon_lumi_coin`, `icon_salt_prism`).
- **Aprimoramento do `AssetManager` (`scripts/core/asset_manager.gd`):**
  - Mapeamento dinâmico de todos os assets com busca insensível a maiúsculas/minúsculas.
  - Sistema de carregamento de fontes personalizadas (`get_font`).
  - Preservação de fallbacks procedurais caso algum arquivo secundário esteja ausente.
- **Integração Visual nas Cenas do Jogo:**
  - Aplicação dos panos de fundo ilustrados com sobreposições calculadas de alto contraste em `MainMenu.tscn`, `PuzzleView.tscn`, `JournalView.tscn`, `CodiceView.tscn`, `CustomizationView.tscn`, `ShopView.tscn` e `SettingsView.tscn`.
- **Configuração de Tipografia Global (`project.godot`):**
  - Definição de `font_body_text.otf` como fonte padrão do projeto na camada GUI, assegurando legibilidade estrita e renderização perfeita de acentuação em português (pt-BR).

---

## [Fase 4 — Conteúdo, Códice & Economia Local] - 2026-10-16


### Adicionado
- **Injeção Integral dos 60 Puzzles Pedagógicos (`data/puzzles/`):**
  - Geração automatizada e rigorosa de todos os 60 arquivos JSON cobrindo as quatro áreas:
    - 15 Puzzles de Matemática (`PUZ_MATH_001` a `015`): frações, razões, equações lineares, Pitágoras, probabilidade e combinatória.
    - 15 Puzzles de Lógica (`PUZ_LOG_001` a `015`): matrizes de dedução, silogismos, diagramas de Venn, indução/dedução e operadores booleanos.
    - 15 Puzzles de Linguagem (`PUZ_LANG_001` a `015`): interpretação de texto explícito e implícito, figuras de linguagem, ambiguidade e coesão textual.
    - 15 Puzzles de Ciências da Natureza (`PUZ_SCI_001` a `015`): alavancas, conservação de energia, fotossíntese, óptica de refração, densidade e biogeoquímica.
  - Cada arquivo possui enunciado narrativo, critérios de validação, 3 níveis de dicas graduais (com custos diegéticos) e catálogo de respostas diagnósticas para erros conceituais típicos.
- **Códice do Conhecimento Completo (`data/codex/`):**
  - 60 verbetes educacionais formatados com resumo conceitual, formulação formal, exemplos resolvidos passo a passo e aplicações práticas na vida real.
  - Sistema de revisão espaçada e acompanhamento de maestria por conceito em `CodiceManager`.
- **Motor e Roteiro de Diálogos Narrativos (`DialogueManager` / `DialogueBox.tscn`):**
  - Implementação de nós de fala ramificados com verificação condicional de flags, itens forenses e verbetes desbloqueados.
  - Redação completa dos roteiros centrais do Prólogo e Capítulos 1 a 4 (`DIA_PROLOGO_01.json`, `DIA_CAP1_01.json`, `DIA_CAP2_01.json`, `DIA_CAP3_01.json`, `DIA_CAP4_01.json`), integrando narrativa de fantasia e causalidade científica real.
- **Loja Diegética Interna e Economia 100% Offline (`ShopManager` / `ShopView.tscn`):**
  - Bazar dos Eruditos de Val-Serena com compra de trajes cosméticos, Runas de Clareza e utilitários usando estritamente a moeda ganha no jogo (Lúmis).
  - Ausência total de compras por dinheiro real, anúncios ou dependências online.
- **Integração dos Assets Audiovisuais Manuais:**
  - Importação de 8 faixas musicais e de ambiência (BGM/BGS) e 5 efeitos sonoros (SFX) com decodificação no motor.
  - Conversão e importação dos panos de fundo de cenários (`bg_title_screen.png`, `bg_blue_glass_crater.png`, `bg_puzzle_desk.png`) e retratos de personagens.

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
