# Diretrizes para Agentes de Desenvolvimento — Echoes of the Veil

Este documento estabelece as instruções permanentes e canônicas para todos os agentes de inteligência artificial e desenvolvedores que atuarem no projeto **Echoes of the Veil**. Qualquer trabalho futuro deve seguir estritamente as regras aqui descritas.

---

## 1. Identidade e Princípio Central: Educação Acima de Tudo

- **Identidade Oficial:** RPG educativo narrativo de fantasia isekai centrado em investigação, raciocínio lógico, interpretação textual e descobertas científicas.
- **Público-Alvo:** Adolescentes de 12 a 17 anos.
- **Princípio Central Inegociável:** **Educação acima de tudo**. A progressão de RPG, a atmosfera de fantasia e as escolhas narrativas existem para servir ao aprendizado, despertando curiosidade e desenvolvendo autonomia intelectual.
- **As Quatro Áreas de Aprendizagem:** Equilíbrio obrigatório entre **Matemática**, **Lógica e Pensamento Crítico**, **Linguagem e Interpretação** e **Ciências**.
- **Engine Oficial:** Godot Engine 4.x com GDScript (respeitando a instalação do ambiente do usuário).
- **Conectividade:** **100% offline após a instalação**. É expressamente proibido projetar dependências de backend, servidores em nuvem obrigatórios, logins remotos ou telemetria invasiva.
- **Plataformas:** Android prioritário; expansão para iOS planejada (condicionada à viabilidade técnica).

---

## 2. Regras Pedagógicas e Adaptação ao Público (12 a 17 anos)

1. **Correção Factual e Científica Absoluta:**
   - Todo conceito matemático, princípio lógico, dado gramatical/textual e fato de ciências (física, química, biologia, astronomia) deve ser **estritamente correto perante o conhecimento científico real**.
   - As regras mágicas de Velathys são diegéticas e devem ser claramente identificadas como pertencentes à ficção cósmica, nunca se misturando ou contradizendo a ciência real.
2. **Sem Infantilização e Sem Academicismo Excessivo:**
   - Comunique-se com naturalidade, seriedade e respeito à inteligência do jovem de 12 a 17 anos. Não utilize tom paternalista ou vocabulário infantilizado. Evite também hermetismos teóricos desnecessários sem contextualização prática.
3. **Pedagogia Sem Punição Destrutiva:**
   - Erros não devem custar itens vitais ou causar retrocessos punitivos. O erro é uma etapa natural de aprendizagem. Todo feedback incorreto deve ser respeitoso, construtivo e diagnóstico, auxiliando o jogador a compreender onde o raciocínio falhou.
4. **O Códice do Conhecimento:**
   - Todo conceito introduzido deve ser documentado no repositório local do *Códice do Conhecimento*, permitindo consulta offline de resumos, exemplos resolvidos, glossário e exercícios voluntários de revisão.

---

## 3. Regras de Arquitetura e Organização

1. **Separação Rígida de Responsabilidades:**
   - **Camada de Apresentação e UI:** Cenas Godot (`.tscn`) compostas por nós de interface (`Control`, `MarginContainer`, `VBoxContainer`, etc.), focadas estritamente em renderização e captura de inputs de toque.
   - **Camada de Lógica de Gameplay:** Scripts GDScript desacoplados da renderização direta, gerenciando estados de quests, validação de respostas e regras de negócio.
   - **Camada de Dados (Content as Data):** Puzzles, diálogos, tabelas de economia e verbetes do Códice devem residir em arquivos estruturados (`.json` ou `Resource` `.tres`), nunca hardcoded dentro de scripts de cena.
2. **Nomenclatura Canônica:**
   - Diretórios: `snake_case` (ex: `scenes/`, `scripts/`, `data/`, `docs/game-design/`).
   - Cenas Godot: `PascalCase.tscn` (ex: `PuzzleBoard.tscn`, `DialogueBox.tscn`).
   - Scripts GDScript: `PascalCase.gd` para classes nomeadas (`class_name PuzzleEngine`), ou `snake_case.gd` para scripts anexos a nós específicos.
   - Recursos e Dados: `snake_case.tres` ou `snake_case.json`.
   - Documentação: `MAIUSCULAS-COM-HIFEN.md` na raiz e pastas técnicas (`GDD.md`, `LEARNING-DESIGN.md`).
3. **Escopo Estrito de Tarefas:**
   - Não implemente funcionalidades fora do escopo exato da tarefa solicitada.
   - Na **Fase 2 (Protótipo Educativo & Vertical Slice)**, implemente a arquitetura base na Godot 4.x e os sistemas essenciais do protótipo de forma modular e desacoplada, sem gerar assets audiovisuais artificiais (utilizando placeholders procedurais limpos no `AssetManager`).

---

## 4. Manutenção da Lore e Coerência Narrativa

1. **Fonte Canônica Única:**
   - A bíblia narrativa reside em [`docs/narrative/LORE-BIBLE.md`](file:///c:/Users/ogust/Desktop/game-isekai/docs/narrative/LORE-BIBLE.md).
   - Nenhuma nova facção, personagem ou evento histórico pode contradizer a documentação narrativa.
2. **Narrativa Integrada à Educação:**
   - Os desafios intelectuais não são provas escolares avulsas; eles são necessidades vitais da trama (consertar canais de água, calcular razões de medicamentos, ler entrelinhas de depoimentos, desatar cifras históricas).
   - O protagonista é um jovem pesquisador com raciocínio metódico, mantendo a verossimilhança ao não expor levianamente sua origem da Terra aos habitantes locais.

---

## 5. Regras para Criação e Validação de Puzzles

1. **Estrutura Obrigatória de Puzzles:**
   - Todo puzzle deve conter: identificador único, área educativa, habilidade-alvo, conhecimentos prévios, dificuldade (1 a 5), contexto narrativo, enunciado, restrições, solução, explicação passo a passo, respostas aceitas, erros comuns, dicas graduais em 3 níveis, exemplo de transferência para outro contexto, recompensas e validação.
2. **Dicas Graduais (Três Níveis):**
   - Nível 1: Direcionamento conceitual (reorientação do olhar).
   - Nível 2: Dica prática (eliminação de hipóteses ou demonstração da primeira etapa).
   - Nível 3: Quase-solução estruturada (como concluir a dedução com autonomia).
3. **Validação Prévia:**
   - Nenhum enigma pode ser adicionado sem ser submetido à lista de verificação de [`docs/puzzles/PUZZLE-QUALITY-CHECKLIST.md`](file:///c:/Users/ogust/Desktop/game-isekai/docs/puzzles/PUZZLE-QUALITY-CHECKLIST.md).

---

## 6. Regras para Utilização de Assets Audiovisuais

1. **Proibição de Geração nesta Etapa:**
   - Não crie, não gere via IA, não baixe da internet e não insira arquivos binários falsos (como arquivos de texto renomeados para `.png` ou `.wav`).
2. **Organização e Manifestos:**
   - Todos os assets fornecidos manualmente pelo usuário no futuro devem ser registrados em [`assets/ASSET-MANIFEST.md`](file:///c:/Users/ogust/Desktop/game-isekai/assets/ASSET-MANIFEST.md), seguindo rigorosamente as convenções de [`assets/README.md`](file:///c:/Users/ogust/Desktop/game-isekai/assets/README.md).

---

## 7. Procedimentos de Atualização e Registro

1. **Atualização do `CHANGELOG.md`:** Registre imediatamente mudanças conceituais e novos marcos com clareza.
2. **Atualização do `ROADMAP.md`:** Acompanhe o progresso nas 7 fases oficiais sem marcar etapas futuras como concluídas.
3. **Consistência de Links:** Verifique se todos os links relativos em Markdown apontam para caminhos válidos. Não deixe links mortos.
