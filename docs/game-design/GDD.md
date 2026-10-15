# GDD — Game Design Document (Documento Mestre de Design)

> **PROJETO:** Echoes of the Veil (Ecos do Véu) — Título Provisório  
> **GÊNERO:** RPG Educativo Narrativo de Fantasia Isekai  
> **PÚBLICO-ALVO:** Adolescentes de 12 a 17 anos  
> **PLATAFORMA INICIAL:** Mobile Android (Expansão para iOS condicionada à viabilidade técnica)  
> **ENGINE:** Godot Engine 4.x (GDScript)  
> **CONECTIVIDADE:** 100% Offline após a instalação (sem dependência de servidores ou contas remotas)  
> **ORIENTAÇÃO DE TELA:** Vertical (*Portrait* 9:16 / 19.5:9)  
> **PRINCÍPIO DIRETOR:** Educação acima de tudo — a narrativa, os puzzles e a progressão servem ao aprendizado significativo.  

---

## 1. Visão Executiva e Proposta Pedagógica

**Echoes of the Veil** combina a imersão de um RPG de fantasia isekai com uma estrutura pedagógica rigorosa desenvolvida para **jovens de 12 a 17 anos**. O jogador assume o papel de um jovem pesquisador da Terra transportado para o mundo de **Velathys**, onde civilizações sucumbiram ao esquecimento e a realidade é mantida por axiomas conceituais.

Ao invés de combates de ação em tempo real ou mecânicas repetitivas de grinding, o jogo coloca a **mente, a curiosidade e o raciocínio ativo** no centro do gameplay. O avanço na trama exige aplicar conceitos reais de **Matemática**, **Lógica e Pensamento Crítico**, **Linguagem e Interpretação** e **Ciências**.

---

## 2. Pilares de Design Educativo

1. **Educação Acima de Tudo:**
   - A qualidade didática, a correção dos conceitos e o desenvolvimento da autonomia intelectual do adolescente sobrepõem-se a sistemas de economia ou cosméticos.
2. **Integração Diegética da Aprendizagem:**
   - O conhecimento não surge em provas escolares artificiais; ele é a ferramenta viva necessária para desvendar documentos antigos, restaurar aquedutos, calcular dosagens de remédios e refutar falsos testemunhos.
3. **Códice do Conhecimento Integrado:**
   - Repositório local e offline que fornece resumos teóricos claros, exemplos comentados, glossário enriquecedor e desafios de revisão voluntária com recompensas.
4. **Respeito e Acessibilidade para 12 a 17 Anos:**
   - Linguagem natural e madura, sem infantilização e sem presunção de conhecimentos avançados prévios. Feedback diagnóstico respeitoso após erros, auxiliando na compreensão do raciocínio.
5. **Experiência Totalmente Offline:**
   - O aplicativo inclui todo o conteúdo no pacote de instalação, operando perfeitamente sem internet, sem anúncios, sem telemetria e sem contas de usuário.

---

## 3. Resumo dos Sistemas de Jogo

| Sistema | Função Principal | Documento Canônico Detalhado |
| :--- | :--- | :--- |
| **Design Pedagógico** | Matriz curricular das 4 áreas, 4 momentos de aprendizagem e Códice. | [`LEARNING-DESIGN.md`](file:///c:/Users/ogust/Desktop/game-isekai/docs/game-design/LEARNING-DESIGN.md) |
| **Exploração e Diálogos** | Navegação por cenários 2D em modo retrato com hotspots interativos e diálogos ramificados. | [`CORE-LOOP.md`](file:///c:/Users/ogust/Desktop/game-isekai/docs/game-design/CORE-LOOP.md) / [`DIALOGUE-GUIDELINES.md`](file:///c:/Users/ogust/Desktop/game-isekai/docs/narrative/DIALOGUE-GUIDELINES.md) |
| **Motor de Puzzles** | Validação determinística de desafios nas 4 áreas educativas com 5 níveis de dificuldade. | [`PUZZLE-DESIGN.md`](file:///c:/Users/ogust/Desktop/game-isekai/docs/game-design/PUZZLE-DESIGN.md) |
| **Gerenciador de Quests** | Quests principais e investigativas que contextualizam os problemas de aprendizagem. | [`QUEST-DESIGN.md`](file:///c:/Users/ogust/Desktop/game-isekai/docs/game-design/QUEST-DESIGN.md) |
| **Progressão por Erudição** | Evolução do protagonista através da compreensão, persistência e aplicação de conceitos. | [`PROGRESSION.md`](file:///c:/Users/ogust/Desktop/game-isekai/docs/game-design/PROGRESSION.md) |
| **Economia Local & Loja** | Moedas internas (*Lúmis* e *Prismas de Sal*) para trajes cosméticos e itens diegéticos (sem pay-to-win). | [`ECONOMY.md`](file:///c:/Users/ogust/Desktop/game-isekai/docs/game-design/ECONOMY.md) |
| **UX & Acessibilidade Mobile**| Operação vertical com uma mão (*Thumb Zone*), fontes escaláveis e mitigação de brilho do SO. | [`MOBILE-UX.md`](file:///c:/Users/ogust/Desktop/game-isekai/docs/game-design/MOBILE-UX.md) / [`SETTINGS.md`](file:///c:/Users/ogust/Desktop/game-isekai/docs/game-design/SETTINGS.md) |

---

## 4. O Fluxo de Sessão de Jogo (Loop Educativo)

Uma sessão típica dura entre 10 e 25 minutos e articula os quatro momentos pedagógicos:
1. **Descoberta:** O jogador explora uma área e depara-se com um mistério diegético (ex: um contrato com datas divergentes).
2. **Prática Guiada:** Através de pistas no Diário de Deduções, o jogador recebe apoio para identificar as variáveis essenciais.
3. **Aplicação Independente:** O jogador resolve o enigma na tela de puzzle, aplicando raciocínio matemático, lógico ou forense com autonomia.
4. **Consolidação:** O Códice do Conhecimento é atualizado com a explicação formal do conceito, liberando Lúmis, XP de Erudição e opções de revisão.
