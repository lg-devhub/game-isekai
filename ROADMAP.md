# ROADMAP — Echoes of the Veil (Planejamento Oficial das 7 Fases)

Este documento apresenta o planejamento estratégico e operacional oficial de **Echoes of the Veil**, estruturado em 7 fases progressivas focadas na entrega de um **RPG educativo narrativo isekai 100% offline** para adolescentes de 12 a 17 anos.

---

## Visão Geral das 7 Fases

```
[Fase 1: Documentação & Consolidação Pedagógica] (CONCLUÍDA)
       │
       ▼
[Fase 2: Protótipo Educativo & Vertical Slice] (CONCLUÍDA)
       │
       ▼
[Fase 3: Sistemas Essenciais de Gameplay] (CONCLUÍDA)
       │
       ▼
[Fase 4: Conteúdo, Códice & Economia Local] (CONCLUÍDA)
       │
       ▼
[Fase 5: Integração Audiovisual dos Assets Manuais] (CONCLUÍDA)
       │
       ▼
[Fase 6: Validação Pedagógica, Acessibilidade & Desempenho] (PRÓXIMA ETAPA)

       │
       ▼
[Fase 7: Preparação para Publicação & Exportação Mobile]
```

---

## Detalhamento das Fases

### Fase 1: Documentação Canônica & Consolidação Pedagógica (Concluída)
- [x] Definição da identidade oficial: RPG educativo isekai com o princípio "Educação acima de tudo".
- [x] Estabelecimento do público-alvo prioritário: adolescentes de 12 a 17 anos.
- [x] Criação do canon pedagógico em [`docs/game-design/LEARNING-DESIGN.md`](file:///c:/Users/ogust\Desktop/game-isekai/docs/game-design/LEARNING-DESIGN.md) cobrindo Matemática, Lógica, Linguagem e Ciências.
- [x] Estruturação dos quatro momentos pedagógicos: Descoberta, Prática Guiada, Aplicação Independente e Consolidação.
- [x] Especificação do sistema local e offline do *Códice do Conhecimento*.
- [x] Elaboração do catálogo inicial de 60 puzzles com habilidades-alvo, erros comuns e transferência conceitual.
- [x] Definição arquitetural na Godot Engine 4.x / GDScript operando 100% offline após instalação.
- [x] Preparação dos diretórios de assets com READMEs explicativos e manifesto em branco.
- [x] Auditoria cruzada de consistência interna e validação de links relativos.

### Fase 2: Protótipo Educativo & Vertical Slice (Concluída)
- [x] Planejamento e criação do projeto base na Godot 4.x com resolução portrait (1080x1920).
- [x] Implementação de experiência curta contendo introdução narrativa da transposição (`Boot.tscn` e `MainMenu.tscn`).
- [x] Desenvolvimento da tela mestre de desafios integrando as quatro áreas: Matemática, Lógica, Linguagem, Ciências (`PuzzleView.tscn`).
- [x] Implementação de dicas graduais de três níveis e sistema de feedback respeitoso e diagnóstico (`PuzzleEngine.gd` e validadores).
- [x] Implementação do salvamento local automático e Códice do Conhecimento offline (`CodiceView.tscn` e `CodiceManager.gd`).

### Fase 3: Sistemas Essenciais de Gameplay (Concluída)
- [x] Implementação do sistema de quests e objetivos investigativos (`QuestManager` e tela `JournalView.tscn` com rastreamento de missões ativas e concluídas).
- [x] Implementação da progressão de Erudição baseada em compreensão e persistência (`ProgressionManager` com 15 níveis, títulos diegéticos e maestria nas 4 áreas).
- [x] Implementação do inventário forense e inspeção de documentos (`InventoryManager`, bolsa de itens utilizáveis e exame pericial com lupa em `FOR_DOC_REGISTRO_AGRIMENSOR`).
- [x] Implementação do menu de configurações (áudio, legibilidade, acessibilidade e gerenciamento seguro de saves locais em `SettingsView.tscn`).
- [x] Sistema de customização estética do protagonista respeitando a coerência da história (`CustomizationView.tscn`).

### Fase 4: Conteúdo, Códice & Economia Local (Concluída)
- [x] Injeção de todos os 60 puzzles pedagógicos estruturados em arquivos JSON externos em `data/puzzles/`.
- [x] Redação completa dos diálogos e roteiros do Prólogo e Capítulos 1 a 4 (`DialogueManager`, `DialogueBox.tscn`, `data/dialogues/*.json`).
- [x] Implementação completa do Códice do Conhecimento com histórico de descobertas, maestria e desafios de revisão espaçada (`CodiceManager`, 60 verbetes em `data/codex/`).
- [x] Implementação da loja diegética interna (`ShopManager`, `catalog.json`, `ShopView.tscn`) com compra de roupas e conveniências exclusivamente com Lúmis conquistadas no jogo (100% offline).


### Fase 5: Integração Audiovisual dos Assets Manuais (Concluída)
- [x] Recebimento e catalogação dos assets reais fornecidos pelo usuário no manifesto ([`ASSET-MANIFEST.md`](file:///c:/Users/ogust/Desktop/game-isekai/assets/ASSET-MANIFEST.md)).
- [x] Integração de ilustrações de cenários em modo retrato, retratos de personagens e ícones (`bg_title_screen`, `bg_puzzle_desk`, `bg_blue_glass_crater`, etc.).
- [x] Integração de trilhas musicais (BGM), ambientes (BGS) e efeitos sonoros táteis (SFX) via `AudioManager` e `AssetManager`.
- [x] Importação de fontes tipográficas com suporte a acentuação latina e configuração no `project.godot`.

### Marco Intermediário: Revisão Prioritária de UI/UX, Personagens e Gameplay (Concluído)
- [x] Resolução da causa-raiz da invisibilidade dos personagens (`customization_view.gd` carrega `CHAR_HERO_PORTRAIT_NEUTRAL`, `DialogueBox.tscn` instanciado nas telas de fala, e `PuzzleView.tscn` equipado com painel de companheiro com expressões dinâmicas de Lyra/Vaelen/Talos-IV).
- [x] Aplicação do tema unificado de RPG de Fantasia (`assets/theme/echoes_theme.tres`) com botões táteis, painéis de ardósia, molduras douradas e fontes temáticas.
- [x] Reestruturação do fluxo inicial: botão "Iniciar Jogo", detecção inteligente de save para "Continuar Jornada", tela de Seleção de Dificuldade (5 níveis) e Introdução Narrativa imersiva.
- [x] Implementação do Mapa de Expedições interativo (`QuestMapView.tscn`) com 4 estados de missão (Concluída, Disponível, Em Progresso, Bloqueada) e cartões detalhados.
- [x] Contextualização RPG completa dos enigmas: habilidade investigativa em destaque, explicações detalhadas passo a passo na vitória e feedback diagnóstico pedagógico.

### Fase 6: Validação Pedagógica, Acessibilidade & Desempenho
- [ ] Auditoria de correção factual de todos os conceitos científicos, matemáticos e linguísticos.
- [ ] Testes de usabilidade e compreensão com jogadores na faixa etária de 12 a 17 anos.
- [ ] Validação rigorosa de execução 100% offline (verificando ausência total de chamadas de rede).
- [ ] Profiling de desempenho em smartphones Android (meta de 60 FPS, < 250 MB RAM, inicialização < 2,5s).
- [ ] Validação de acessibilidade (filtros de daltonismo, contraste e escala de texto).

### Fase 7: Preparação para Publicação & Exportação Mobile
- [ ] Geração e assinatura do pacote Android App Bundle (`.aab`) para Google Play Store.
- [ ] Avaliação técnica de viabilidade e pipeline de exportação para iOS (Xcode / App Store).
- [ ] Documentação de conformidade com LGPD/GDPR e políticas de privacidade para menores de idade.
- [ ] Lançamento oficial da versão estável.
