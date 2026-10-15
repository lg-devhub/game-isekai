# CONTEXT.md — Contexto Central do Projeto

## 1. Resumo Executivo do Jogo

**Echoes of the Veil** (título provisório) é um **RPG educativo narrativo de fantasia isekai** para dispositivos móveis (Android prioritário; iOS condicionado à viabilidade técnica), desenvolvido na **Godot Engine 4.x** com **GDScript**. O jogo funciona de forma **totalmente offline após a instalação**, sem dependência de internet, contas de usuário ou microtransações.

O jogador assume o papel de um jovem pesquisador contemporâneo transportado para o mundo de **Velathys**, uma realidade onde o esquecimento consome civilizações e a estabilidade da existência depende da redescoberta de axiomas fundamentais. 

O jogo adota o princípio central de **"Educação acima de tudo"**: a fantasia, a atmosfera de mistério e a progressão de RPG servem como veículos de engajamento para desenvolver competências cognitivas e acadêmicas em quatro grandes áreas do conhecimento: **Matemática**, **Lógica e Pensamento Crítico**, **Linguagem e Interpretação** e **Ciências**.

---

## 2. Decisões Oficiais Consolidadas

| Aspecto | Decisão | Status | Documento Canônico |
| :--- | :--- | :---: | :--- |
| **Identidade** | RPG educativo narrativo de fantasia isekai | **Confirmada** | [`docs/game-design/GDD.md`](file:///c:/Users/ogust/Desktop/game-isekai/docs/game-design/GDD.md) |
| **Título** | *Echoes of the Veil* | **Provisório** | Raiz / Marca |
| **Público-Alvo** | Adolescentes de 12 a 17 anos | **Confirmada** | [`docs/game-design/LEARNING-DESIGN.md`](file:///c:/Users/ogust/Desktop/game-isekai/docs/game-design/LEARNING-DESIGN.md) |
| **Tecnologia** | Godot Engine 4.x e GDScript | **Confirmada** | [`docs/technical/TECH-STACK.md`](file:///c:/Users/ogust/Desktop/game-isekai/docs/technical/TECH-STACK.md) |
| **Plataforma Inicial** | Android (APK / AAB) | **Confirmada** | [`docs/technical/ARCHITECTURE.md`](file:///c:/Users/ogust/Desktop/game-isekai/docs/technical/ARCHITECTURE.md) |
| **Expansão Futura** | iOS (condicionada à viabilidade técnica) | **Planejada** | [`ROADMAP.md`](file:///c:/Users/ogust/Desktop/game-isekai/ROADMAP.md) |
| **Conectividade** | Totalmente offline após a instalação | **Confirmada** | [`docs/technical/PERFORMANCE-AND-SECURITY.md`](file:///c:/Users/ogust/Desktop/game-isekai/docs/technical/PERFORMANCE-AND-SECURITY.md) |
| **Idioma Inicial** | Português do Brasil (`pt-BR`) com i18n | **Confirmada** | [`docs/technical/DATA-MODEL.md`](file:///c:/Users/ogust/Desktop/game-isekai/docs/technical/DATA-MODEL.md) |
| **Foco Pedagógico** | Matemática, Lógica, Linguagem e Ciências | **Confirmada** | [`docs/game-design/LEARNING-DESIGN.md`](file:///c:/Users/ogust/Desktop/game-isekai/docs/game-design/LEARNING-DESIGN.md) |
| **Estrutura de Desafios**| 5 níveis principais de dificuldade | **Confirmada** | [`docs/puzzles/PUZZLE-TAXONOMY.md`](file:///c:/Users/ogust/Desktop/game-isekai/docs/puzzles/PUZZLE-TAXONOMY.md) |
| **Recursos Audiovisuais**| Fornecidos manualmente pelo usuário | **Confirmada** | [`assets/README.md`](file:///c:/Users/ogust/Desktop/game-isekai/assets/README.md) |
| **Estado Atual** | Planejamento e documentação (sem jogo implementado) | **Confirmada** | [`README.md`](file:///c:/Users/ogust/Desktop/game-isekai/README.md) |

---

## 3. Princípio Central: Educação Acima de Tudo

O jogo prioriza a aprendizagem significativa em relação a sistemas cosméticos ou de monetização. A experiência não se resume a quizzes de múltipla escolha com recompensas rasas; busca estimular a **autonomia intelectual, a formulação de hipóteses, a compreensão do erro e a transferência de conceitos para novas situações**:

1. **Correção Absoluta:** Conteúdos científicos, matemáticos e linguísticos são rigorosamente exatos perante o conhecimento formal. A magia é diegética e nunca é confundida com fatos da ciência real.
2. **Pedagogia Sem Punição:** Erros não impõem perda de progresso destrutiva nem forçam repetições mecânicas tediosas; fornecem feedback diagnóstico orientador.
3. **Códice do Conhecimento:** Repositório acessível 100% offline contendo resumos explicativos, exemplos resolvidos, glossário e desafios de fixação.
4. **Respeito ao Público de 12 a 17 Anos:** Linguagem madura, envolvente e natural, sem infantilização e sem pedantismo acadêmico inacessível.

---

## 4. As Quatro Grandes Áreas Educativas

```
┌────────────────────────────────────────────────────────────────────────┐
│                      EQUILÍBRIO PEDAGÓGICO                             │
├───────────────────┬────────────────────────────────────────────────────┤
│ MATEMÁTICA        │ Operações, proporções, frações, álgebra, geometria,│
│                   │ combinatória, probabilidade, tabelas e otimização. │
├───────────────────┼────────────────────────────────────────────────────┤
│ LÓGICA & CRÍTICA  │ Dedução, indução, causa-efeito, matrizes lógicas,  │
│                   │ identificação de contradições, falácias e hipóteses│
├───────────────────┼────────────────────────────────────────────────────┤
│ LINGUAGEM & TEXTO │ Interpretação textual, vocabulário em contexto,    │
│                   │ metáforas, ambiguidade, charadas, cifras e códices.│
├───────────────────┼────────────────────────────────────────────────────┤
│ CIÊNCIAS          │ Método científico, física básica (ótica, alavancas)│
│                   │ química introdutória, astronomia e ecossistemas.   │
└───────────────────┴────────────────────────────────────────────────────┘
```

---

## 5. Estrutura dos Momentos Pedagógicos Recorrentes

Cada competência educativa é trabalhada através de quatro momentos estruturados:
1. **Descoberta:** Uma situação dramática ou observação de cenário desperta curiosidade e introduz o conceito organicamente.
2. **Prática Guiada:** Um desafio inicial contextualizado com suporte e andaime pedagógico (*scaffolding*).
3. **Aplicação Independente:** Um problema novo onde o jogador mobiliza o conceito com autonomia e raciocínio próprio.
4. **Consolidação:** Explicação passo a passo no Códice do Conhecimento, estabelecendo relações interdisciplinares e oferecendo revisões opcionais.

---

## 6. Mapa Documental Atualizado

```text
game-isekai/
├── AGENTS.md                  # Instruções para agentes e desenvolvedores
├── CONTEXT.md                 # Contexto consolidado (este arquivo)
├── README.md                  # Apresentação do projeto e estado atual
├── CHANGELOG.md               # Histórico de alterações do projeto
├── ROADMAP.md                 # Fases em 7 etapas da documentação ao lançamento
├── GLOSSARY.md                # Glossário de termos de lore, gameplay e pedagogia
│
├── docs/
│   ├── game-design/           # GDD, Pedagogia, Core Loop, Quests, Economia, UX
│   │   ├── GDD.md
│   │   ├── LEARNING-DESIGN.md # [CANON PEDAGÓGICO] Áreas, matriz curricular e Códice
│   │   ├── CORE-LOOP.md
│   │   ├── PUZZLE-DESIGN.md
│   │   ├── QUEST-DESIGN.md
│   │   ├── PROGRESSION.md
│   │   ├── ECONOMY.md
│   │   ├── CHARACTER-CUSTOMIZATION.md
│   │   ├── MOBILE-UX.md
│   │   └── SETTINGS.md
│   │
│   ├── narrative/             # Lore adaptada para 12-17 anos, mundo e campanha
│   │   ├── LORE-BIBLE.md
│   │   ├── WORLD-BUILDING.md
│   │   ├── TIMELINE.md
│   │   ├── CHARACTERS.md
│   │   ├── FACTIONS.md
│   │   ├── STORY-STRUCTURE.md
│   │   ├── DIALOGUE-GUIDELINES.md
│   │   └── LORE-REVEAL-PLAN.md
│   │
│   ├── puzzles/               # Catálogo de 60 puzzles pedagógicos e validação
│   │   ├── PUZZLE-CATALOG.md
│   │   ├── PUZZLE-TAXONOMY.md
│   │   ├── PUZZLE-QUALITY-CHECKLIST.md
│   │   └── PUZZLE-CONTENT-SCHEMA.md
│   │
│   └── technical/             # Arquitetura Godot 4.x 100% offline e modelos locais
│       ├── ARCHITECTURE.md
│       ├── TECH-STACK.md
│       ├── DATA-MODEL.md
│       ├── SAVE-SYSTEM.md
│       ├── AUDIO-VISUAL-INTEGRATION.md
│       ├── TESTING-STRATEGY.md
│       └── PERFORMANCE-AND-SECURITY.md
│
└── assets/                    # Estrutura com READMEs e ASSET-MANIFEST.md
```

---

## 7. Riscos e Mitigações Pedagógicas

- **Risco 1: Sensação de "Prova Escolar Disfarçada".** Puzzles que pareçam exercícios de apostila desengajam adolescentes.  
  *Mitigação:* Cada desafio deve resolver um conflito diegético imediato (consertar um aqueduto, desmascarar uma fraude fiscal, salvar um inocente com química/ervas).
- **Risco 2: Heterogeneidade de Conhecimento Prévio.** Jogadores de 12 anos possuem repertório diferente de jovens de 17.  
  *Mitigação:* O jogo não presume conhecimentos prévios avançados; introduz os axiomas necessários na etapa de Descoberta e oferece o Códice do Conhecimento para consulta a qualquer momento.
- **Risco 3: Tentativa e Erro Desordenada (*Brute Force*).** Jogadores clicando aleatoriamente sem pensar.  
  *Mitigação:* Interfaces com confirmação de raciocínio, dicas de reorientação reflexiva e incentivos por dedução analítica consciente.
