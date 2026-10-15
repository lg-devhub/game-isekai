# PUZZLE-QUALITY-CHECKLIST — Lista de Verificação de Qualidade e Validação Pedagógica

Todo puzzle deve passar com sucesso por todos os itens desta lista de verificação antes de ser incorporado ao catálogo canônico ou implementado no código da engine.

---

## 1. Verificação de Rigor Científico e Correção Pedagógica

- [ ] **Correção Factual Absoluta:** Todos os conceitos de física, química, biologia, matemática e gramática são rigorosamente corretos no mundo real.
- [ ] **Distinção entre Ciência e Ficção:** O enigma não confunde regras mágicas fictícias com leis naturais reais. A magia opera como complemento metafísico respeitoso à conservação de energia.
- [ ] **Adequação ao Público de 12 a 17 Anos:** A linguagem do enunciado é clara, madura e engajadora, evitando infantilização ou academicismo hermético.
- [ ] **Presença de Habilidade-Alvo e Conhecimentos Prévios:** O desafio define com precisão a competência escolar trabalhada e não presume conhecimentos avançados sem introduzi-los previamente.
- [ ] **Exemplo de Transferência Documentado:** Cada puzzle possui documentado um exemplo claro de como o conceito pode ser aplicado em outra situação (seja no mundo real ou em outros momentos do jogo).

---

## 2. Não-Ambiguidade e Solucionabilidade Lógica

- [ ] **Determinismo da Resposta:** O problema possui uma solução logicamente verificável e matematicamente incontestável.
- [ ] **Auditoria de Cálculos:** Todas as operações, frações, equações e razões foram recalculadas e comprovadas sem ambiguidades de arredondamento.
- [ ] **Normalização Textual:** Para respostas digitadas por texto (`TEXT_INPUT`), foram cadastradas alternativas equivalentes (singular/plural, sinônimos pertinentes) e o validador ignora maiúsculas/minúsculas e acentuação diacrítica.
- [ ] **Tratamento de Erros Comuns:** Os equívocos típicos cometidos por estudantes (ex: confundir soma com multiplicação, esquecer unidades de medida) foram previstos para orientar o feedback diagnóstico.

---

## 3. Estrutura de Dicas e Andaime (*Scaffolding*)

- [ ] **Três Níveis de Dica Cadastrados:**
  - Nível 1: Direcionamento conceitual sutil (reorienta o foco).
  - Nível 2: Dica prática (elimina hipóteses falsas ou demonstra o primeiro passo).
  - Nível 3: Quase-solução estruturada (fornece a fórmula final, preservando a dedução ativa).
- [ ] **Respeito à Economia:** As dicas não exigem compras com dinheiro real e são adquiríveis com Lúmis obtidos pela própria exploração offline.

---

## 4. Integração Narrativa e Mobile UX

- [ ] **Necessidade Diegética:** A resolução do enigma é necessária para resolver um conflito real da história (reparar aquedutos, curar intoxicação, decifrar códices).
- [ ] **Acessibilidade Cromática:** Não depende exclusivamente de cores para indicar estados (usa formas e símbolos complementares).
- [ ] **Ergonomia de Toque:** Elementos interativos respeitam o tamanho mínimo de 48x48 dp para toque confortável em smartphones.
