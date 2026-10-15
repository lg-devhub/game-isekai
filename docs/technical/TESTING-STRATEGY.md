# TESTING-STRATEGY — Estratégia de Testes e Garantia de Qualidade

Este documento define o plano de testes, as metodologias de validação automatizada e os procedimentos de homologação para **Echoes of the Veil** na Godot 4.x, integrando critérios de qualidade de software e validação pedagógica ([`PUZZLE-QUALITY-CHECKLIST.md`](file:///c:/Users/ogust/Desktop/game-isekai/docs/puzzles/PUZZLE-QUALITY-CHECKLIST.md)).

---

## 1. Níveis da Pirâmide de Testes

```
              ┌───────────────────────────┐
              │  TESTES EM DISPOSITIVOS   │ ◄── Testes manuais em smartphones
              │     FÍSICOS (MANUAL)      │     Android reais (toque, ergonomia, bateria)
              ├───────────────────────────┤
              │   TESTES DE INTEGRAÇÃO    │ ◄── Fluxo completo: Diálogo ➔ Puzzle ➔
              │   E PROGRESSÃO DE TELAS   │     Feedback ➔ Códice ➔ Salvamento em disco
              ├───────────────────────────┤
              │   TESTES UNITÁRIOS COM    │ ◄── Validação dos 4 validadores pedagógicos,
              │    BIBLIOTECA GUT (CI)    │     lógica de puzzles e SaveSystem local
              ├───────────────────────────┤
              │ VALIDAÇÃO ESTÁTICA JSON   │ ◄── Scripts de validação de schemas de
              │    (SCHEMA COMPLIANCE)    │     dados de puzzles, quests e Códice
              └───────────────────────────┘
```

---

## 2. Testes Unitários Automatizados com GUT (*Godot Unit Testing*)

A biblioteca de código aberto **GUT** para Godot 4.x será integrada na Fase 2 para execução de testes rápidos de regressão em linha de comando (CLI) e no editor:

### Áreas Cobertas por Testes Unitários:
1. **Validadores Pedagógicos de Puzzles (`test_puzzle_validators.gd`):**
   - **`MathValidator`:** Testa tolerâncias numéricas infinitesimais, cálculos com frações e sistemas lineares para os puzzles `MATH-001` a `MATH-015`.
   - **`LogicValidator`:** Testa a consistência de circuitos booleanos, tabelas de verdade e silogismos para os puzzles `LOG-001` a `LOG-015`.
   - **`LanguageValidator`:** Testa a normalização de texto (remoção de acentos, pontuação e indiferença entre maiúsculas/minúsculas) e correspondência de respostas para `LANG-001` a `LANG-015`.
   - **`ScienceValidator`:** Testa equivalência de grandezas físicas e conversão de unidades no Sistema Internacional para `SCI-001` a `SCI-015`.
2. **Validação do Sistema de Feedback Diagnóstico:**
   - Para cada quebra-cabeça, testa se a inserção de erros cadastrados no campo `common_errors` dispara o feedback explicativo correspondente sem acionar penalidades destrutivas de recursos vitais.
3. **Sistema de Salvamento Atômico (`test_save_system.gd`):**
   - Testa a escrita atômica em arquivo temporário e renomeação local.
   - Testa a corrupção intencional de um arquivo JSON simulado e verifica se o sistema carrega com sucesso o arquivo `.bak` de recuperação.
   - Testa a integridade dos registros do *Códice do Conhecimento* após salvamentos sucessivos.
4. **Economia e Inventário Éticos (`test_economy_manager.gd`):**
   - Testa se o sistema bloqueia qualquer tentativa de compra de dicas ou respostas usando dinheiro real.
   - Valida que moedas de gameplay (Lúmis) são consumidas apenas de forma transparente mediante confirmação voluntária.

---

## 3. Script Automatizado de Validação de Schemas JSON

Antes de cada commit ou build, um script utilitário (`scripts/tools/validate_puzzle_data.gd`) varre as pastas `data/puzzles/`, `data/quests/` e `data/codex/`, executando:
- Verificação se todos os campos obrigatórios do esquema JSON ([`PUZZLE-CONTENT-SCHEMA.md`](file:///c:/Users/ogust/Desktop/game-isekai/docs/puzzles/PUZZLE-CONTENT-SCHEMA.md)) estão presentes;
- Verificação de unicidade estrita da solução cadastrada;
- Verificação da existência de exatamente 3 níveis graduais de dicas;
- Verificação de presença do exemplo prático de transferência (`transfer_example`);
- Alerta sobre IDs duplicados ou referências a capítulos inexistentes.

---

## 4. Testes de Interface e Resolução Mobile

| Teste de UI | Cenário de Validação | Critério de Aceitação |
| :--- | :--- | :--- |
| **Ergonomia de Toque** | Testar em tela de 5.5 polegadas | Todos os botões e áreas interativas possuem área mínima de toque de 48x48 dp. |
| **Notch / Safe Area** | Testar em dispositivo com recorte de câmera | Nenhum texto ou botão de cabeçalho fica encoberto pelo notch ou câmera frontal. |
| **Adaptação de Aspecto** | Testar em proporções 16:9, 19.5:9 e 20:9 | Os painéis verticais se expandem harmoniosamente sem barras pretas laterais ou cortes verticais. |
| **Troca de Escala de Fonte** | Alternar entre 16pt, 20pt e 24pt | Textos longos do Códice ativam barra de rolagem sem estourar as margens do contêiner. |

---

## 5. Homologação em Dispositivos Físicos

Na Fase 5 do Roadmap, o jogo será testado em três perfis de hardware móvel:
1. **Aparelho de Entrada (Low-End):** Android com 3 GB de RAM e processador quad-core (Meta: 45-60 FPS, tempo de carregamento < 4s).
2. **Aparelho Intermediário (Mid-Range):** Android com 6 GB de RAM e tela AMOLED 90/120 Hz (Meta: 60 FPS estáveis, consumo de bateria < 8% por hora de jogo).
3. **Aparelho Topo de Linha (High-End / iOS):** iPhone recente / Android flagship (Meta: 60 FPS perfeitos, renderização nítida de fontes e transições fluidas).
