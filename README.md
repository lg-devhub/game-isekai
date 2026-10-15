# Echoes of the Veil (Ecos do Véu) — RPG Educativo Isekai

> **AVISO IMPORTANTE:** Este repositório encontra-se atualmente na **Fase 1: Documentação Canônica e Planejamento Arquitetural**. Não há código executável ou versão jogável implementada nesta etapa, e nenhum asset audiovisual artificial foi gerado. Toda a base técnica, narrativa e pedagógica está sendo estabelecida como fonte de verdade para as fases subsequentes de desenvolvimento.

---

## 1. Visão Geral

**Echoes of the Veil** é um **RPG educativo narrativo de fantasia isekai** desenvolvido prioritariamente para celulares Android (com expansão planejada para iOS), concebido na **Godot Engine 4.x** utilizando **GDScript**. O jogo funciona de forma **totalmente offline após a instalação**, sem dependência de internet ou contas de usuário.

Desenvolvido para **adolescentes de 12 a 17 anos**, o jogo coloca o princípio **"Educação acima de tudo"** no centro da experiência: a atmosfera de mistério, a exploração de civilizações antigas e o desenvolvimento de personagens servem como esteio para a aprendizagem significativa em quatro grandes disciplinas:
- **Matemática** (proporções, equações, combinatória, geometria e dados);
- **Lógica e Pensamento Crítico** (dedução, identificação de contradições, causalidade e análise de hipóteses);
- **Linguagem e Interpretação** (leitura em contexto, figuras de linguagem, inferências e charadas);
- **Ciências** (método científico, física básica, astronomia, química introdutória e ecossistemas).

---

## 2. Pilares da Experiência Educativa

1. **Aprendizagem Significativa:** Os enigmas não são quizzes descontextualizados; são problemas reais do mundo ficcional (conserto de comportas, cálculo de dosagem farmacológica, desmascaramento de fraudes documentais).
2. **Códice do Conhecimento:** Sistema acessível a qualquer momento offline que reúne resumos teóricos concisos, exemplos resolvidos, glossário temático e desafios voluntários de fixação.
3. **Respeito ao Jovem de 12 a 17 Anos:** Prosa madura, reflexiva e desafiadora, evitando tom paternalista ou infantilização.
4. **Ergonomia e Conectividade Mobile:** Operação vertical (*portrait*) com uma mão, sem compras de vantagens pedagógicas e 100% executável sem rede.

---

## 3. Estrutura do Repositório

```text
game-isekai/
├── AGENTS.md                  # Diretrizes permanentes para agentes e desenvolvedores
├── CONTEXT.md                 # Visão geral de alto nível, decisões oficiais e riscos
├── README.md                  # Este documento
├── CHANGELOG.md               # Histórico documental de alterações e marcos
├── ROADMAP.md                 # Planejamento das 7 fases de desenvolvimento
├── GLOSSARY.md                # Glossário de termos de lore, gameplay e pedagogia
│
├── docs/                      # Documentação canônica do projeto
│   ├── game-design/           # GDD, Pedagogia, Core Loop, Quests, Economia, UX Mobile
│   ├── narrative/             # Bíblia de Lore, Mundos, Personagens, Campanhas
│   ├── puzzles/               # Catálogo com 60 enigmas pedagógicos e taxonomia
│   └── technical/             # Arquitetura Godot 4.x 100% offline, Dados e Saves
│
└── assets/                    # Estrutura preparada para receber recursos manuais
    ├── README.md              # Convenções gerais de importação
    ├── ASSET-MANIFEST.md      # Registro e rastreamento de assets reais
    ├── audio/                 # Pastas para música, ambiente, SFX e voz
    ├── images/                # Personagens, cenários, UI, ícones, itens
    ├── fonts/                 # Tipografias e fontes de interface
    ├── animation/             # Arquivos de animação 2D e sprites
    └── video/                 # Cenas pré-renderizadas de introdução
```

---

## 4. Como Navegar na Documentação

- **Para entender a proposta pedagógica:** [`docs/game-design/LEARNING-DESIGN.md`](file:///c:/Users/ogust/Desktop/game-isekai/docs/game-design/LEARNING-DESIGN.md)
- **Para entender o Game Design geral:** [`docs/game-design/GDD.md`](file:///c:/Users/ogust/Desktop/game-isekai/docs/game-design/GDD.md) e [`docs/game-design/CORE-LOOP.md`](file:///c:/Users/ogust/Desktop/game-isekai/docs/game-design/CORE-LOOP.md)
- **Para explorar a história e o universo:** [`docs/narrative/LORE-BIBLE.md`](file:///c:/Users/ogust/Desktop/game-isekai/docs/narrative/LORE-BIBLE.md) e [`docs/narrative/STORY-STRUCTURE.md`](file:///c:/Users/ogust/Desktop/game-isekai/docs/narrative/STORY-STRUCTURE.md)
- **Para consultar os 60 desafios educativos:** [`docs/puzzles/PUZZLE-CATALOG.md`](file:///c:/Users/ogust/Desktop/game-isekai/docs/puzzles/PUZZLE-CATALOG.md)
- **Para verificar a arquitetura técnica Godot 4.x:** [`docs/technical/ARCHITECTURE.md`](file:///c:/Users/ogust/Desktop/game-isekai/docs/technical/ARCHITECTURE.md) e [`docs/technical/TECH-STACK.md`](file:///c:/Users/ogust/Desktop/game-isekai/docs/technical/TECH-STACK.md)
