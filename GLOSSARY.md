# GLOSSARY — Glossário Geral do Projeto

Este glossário define a terminologia padronizada de **Echoes of the Veil**, cobrindo o universo ficcional (lore), conceitos pedagógicos e educativos, mecânicas de gameplay e sistemas técnicos.

---

## 1. Termos Pedagógicos e Educativos

- **Aplicação Independente:** O terceiro momento da aprendizagem, onde o jogador mobiliza um conceito recém-aprendido em um novo enigma autônomo, sem apoios imediatos.
- **Códice do Conhecimento:** Sistema acessível durante todo o jogo (100% offline) que armazena resumos conceituais concisos, exemplos resolvidos, soluções comentadas, conexões interdisciplinares e desafios opcionais de revisão.
- **Consolidação:** O quarto momento da aprendizagem, onde o raciocínio é explicado passo a passo, contextualizado no Códice e conectado a outros conceitos do mundo real e da narrativa.
- **Descoberta:** O primeiro momento da aprendizagem, no qual uma situação narrativa ou mistério desperta curiosidade e introduz um problema antes da formalização teórica.
- **Educação Acima de Tudo:** O princípio diretor inegociável do projeto. Os sistemas de jogo, a economia e a narrativa existem primariamente para promover a autonomia intelectual, o pensamento crítico e a compreensão de conceitos de matemática, lógica, linguagem e ciências.
- **Feedback Diagnóstico:** Resposta do jogo a um erro do jogador que busca identificar respeitosamente se a falha decorreu de cálculo aritmético, interpretação de texto ou aplicação de regras lógicas, sem penalizar ou frustrar.
- **Prática Guiada:** O segundo momento da aprendizagem, onde um desafio inicial é apresentado com apoio contextual (*scaffolding*), direcionando a atenção para as variáveis relevantes.
- **Quatro Áreas de Aprendizagem:**
  1. *Matemática:* Operações, proporções, álgebra, geometria, combinatória e dados.
  2. *Lógica e Pensamento Crítico:* Dedução, indução, causa e efeito, identificação de contradições e falácias.
  3. *Linguagem e Interpretação:* Leitura crítica, vocabulário em contexto, figuras de linguagem, metáforas e mensagens codificadas.
  4. *Ciências:* Método científico, observação e hipóteses, física básica, astronomia, química introdutória e ecossistemas.
- **Revisão Espaçada Offline:** Mecanismo voluntário no Códice do Conhecimento que oferece novos desafios variados sobre conceitos já aprendidos em capítulos anteriores.
- **Transferência Conceitual:** Capacidade demonstrada pelo jogador de aplicar um princípio matemático, científico ou lógico aprendido em uma quest em uma situação completamente diferente.

---

## 2. Termos do Universo e Lore

- **Aethel-Khor (A Primeira Aurora):** A civilização mais remota de Velathys, cujos sábios desenvolveram a geometria primordial e erigiram os primeiros monumentos causais antes da Grande Fratura.
- **Anômalo (O Não-Inscrito):** Denominação pejorativa dada pela *Ordem do Selo* a indivíduos cuja assinatura existencial não consta no Registro de Almas do Véu. O protagonista é o principal exemplo contemporâneo.
- **Ark-Mnemona:** A Cidadela-Biblioteca suspensa sobre o Vale de Lápis, centro de estudos dos escribas que buscam recuperar o conhecimento apagado.
- **Asma de Éter:** Sensação de respiração áspera sentida ao inalar ar com alta densidade de partículas de sílica e quartzo em Velathys.
- **Entropia Semântica:** A força metafísica que atua quando uma ideia ou fato histórico é esquecido, manifestando-se fisicamente como sal cristalino branco e vazio perceptual.
- **Inscritos (Solemnianos):** Autômatos esculpidos em alabastro e calcário pela Segunda Civilização, portadores de núcleos de quartzo com memórias antigas.
- **Lúmis:** A moeda padrão de troca comercial em Velathys. Moedas octogonais cunhadas em prata antiga e quartzo.
- **Núcleo Áfono:** O artefato cúbico de bronze e lápis-lazúli que o protagonista examinava no momento da transposição da Terra para Velathys.
- **Ordem do Selo Inviolável:** A instituição teocrática e militar dominante nos Sete Vales que queima livros alegando proteger a humanidade da "soberba do conhecimento".
- **Praga das Sombras Brancas:** Condição em que pessoas e locais perdem suas memórias e viram sal, decorrente das fogueiras de livros da Ordem.
- **Prisma de Sal:** Moeda rara e mineral formado pela cristalização de memórias estabilizadas antes de sua dissolução total.
- **Sensibilidade Prismática:** Percepção visual aguçada do protagonista, que enxerga aberrações cromáticas e linhas de tensão em locais adulterados ou com inconsistências lógicas.
- **Solemnia (O Império de Alabastro):** A Segunda Civilização histórica, focada na arquitetura monumental e na preservação da mente em corpos de pedra.
- **Val-Serena:** Vale fértil e cidade mercantil onde se inicia o Capítulo 1 do jogo, construída sobre aquedutos solemnianos.
- **Véu (O Véu de Axiomas):** A membrana cósmica que sustenta a realidade de Velathys, separando a existência compreensível do caos exterior.

---

## 3. Conceitos e Sistemas de Gameplay

- **Diário de Deduções:** Ferramenta interativa que organiza pistas e testemunhos colhidos durante investigações.
- **Erudição (Nível do Protagonista):** Medida de maturidade intelectual e compreensão do protagonista (Níveis 1 a 10), avançada pela persistência e resolução de desafios educativos.
- **Inspeção Forense:** Modo de interface em que objetos 2D são rotacionados e examinados sob filtros visuais em busca de evidências materiais.
- **Níveis de Dica (1, 2 e 3):**
  - *Dica 1 (Rumor):* Direcionamento conceitual sutil.
  - *Dica 2 (Indício):* Eliminação de hipóteses incorretas ou demonstração de etapa intermediária.
  - *Dica 3 (Axioma):* Quase-solução estruturada que preserva a conclusão ativa do jogador.
- **Operação 100% Offline:** Garantia técnica de que todas as quests, diálogos, puzzles, Códice e dados do jogo funcionam sem exigir conexão com a internet após a instalação.

---

## 4. Termos Técnicos do Projeto (Godot 4.x)

- **Autoload / Singleton:** Nós globais instanciados no ciclo de vida do jogo (`GameManager`, `SaveSystem`, `PuzzleEngine`, `SettingsManager`, `AudioManager`).
- **Custom Resource (`.tres`):** Objeto de dados derivado de `Resource` na Godot 4.x para inventário, itens cosméticos e definições do Códice.
- **JSON Schema:** Arquivo de especificação que valida a estrutura formal de dados externos de puzzles e quests.
- **Mobile Safe Area:** Ajuste automático de layout para evitar sobreposição de botões com entalhes de tela (*notches*) e câmeras frontais (`DisplayServer.get_display_safe_area()`).
- **Portrait Anchor:** Sistema de ancoragem de controles em proporção vertical (9:16 base), adaptável a telas longas (19.5:9 e 20:9).
