# QUEST-DESIGN — Arquitetura de Quests e Objetivos Pedagógicos

Este documento detalha o sistema de missões de **Echoes of the Veil**, definindo como as quests principais e secundárias integram objetivos narrativos e metas de aprendizagem significativas nas quatro grandes áreas do conhecimento.

---

## 1. Princípios de Integração entre Quest e Aprendizagem

1. **Narrativa com Propósito Intelectual:**
   - Toda quest apresenta um problema autêntico de Velathys que exige a mobilização de competências escolares (calcular a diluição de um medicamento, deduzir álibis contraditórios, calibrar contrapesos mecânicos ou interpretar metáforas em epitáfios).
2. **Ciclo dos Quatro Momentos Pedagógicos:**
   - As etapas da quest distribuem os momentos de *Descoberta*, *Prática Guiada*, *Aplicação Independente* e *Consolidação no Códice do Conhecimento*.
3. **Múltiplas Trilhas de Solução:**
   - Quests investigativas admitem resoluções alternativas (via perícia forense-material, análise lógica de testemunhos ou negociação dialética baseada em documentos).

---

## 2. Modelo Formal de Quest Pedagógica (Template JSON)

As missões são estruturadas em arquivos externos em `data/quests/` conforme o contrato formal:

```json
{
  "id": "QP_01_RESPIRACAO_VIDRO",
  "type": "MAIN_QUEST",
  "chapter": 0,
  "title": "Respiração de Vidro",
  "pedagogical_area": "MATHEMATICS_AND_SCIENCES",
  "learning_objective": "Compreender e aplicar o conceito de razão e proporção direta em soluções líquidas.",
  "narrative_context": "O protagonista sofre de Asma de Éter devido à inalação de partículas de quartzo na Cratera de Vidro Azul. Lyra Vance possui seiva de anis, mas precisa preparar a diluição exata para aliviar a asfixia.",
  "characters_involved": ["PROTAGONIST", "LYRA_VANCE"],
  "stages": [
    {
      "stage_id": 1,
      "pedagogical_moment": "DISCOVERY",
      "name": "Encontro na Orla da Cratera",
      "description": "Examinar as raízes de anis silvestre e observar os sintomas respiratórios.",
      "related_puzzles": []
    },
    {
      "stage_id": 2,
      "pedagogical_moment": "INDEPENDENT_APPLICATION",
      "name": "Calibração da Tisana Medicinal",
      "description": "Calcular a proporção direta entre seiva e água mineral para produzir o remédio.",
      "related_puzzles": ["PUZ_LM_001_CALIBRACAO_ANIS"]
    },
    {
      "stage_id": 3,
      "pedagogical_moment": "CONSOLIDATION",
      "name": "Alívio dos Sintomas e Registro no Códice",
      "description": "Ingerir a solução e registrar a fórmula proporcional no Códice do Conhecimento.",
      "related_puzzles": []
    }
  ],
  "rewards": {
    "erudition_xp": 100,
    "lumis": 50,
    "codex_entry_unlocked": "CODEX_MATH_PROPORTIONS_01",
    "item_reward_id": "ITEM_TISANA_ESTABILIZADORA"
  },
  "narrative_consequences": {
    "world_state_flag": "PROTAGONIST_HEALED_FROM_ETHER_ASTHMA"
  }
}
```

---

## 3. Quests Investigativas e Secundárias

Quests secundárias ampliam a compreensão da história e exercitam competências interdisciplinares:
- **`QS_02: A Balança do Mercador`:** Matemática e Lógica — resolução de equações do primeiro grau e equilíbrio de balanças em fraude fiscal.
- **`QS_03: O Caderno Criptografado do Avô`:** Ciências e Linguagem — botânica medicinal, extração de princípios ativos e decifração de cifras de substituição simples.
- **`QS_05: As Moedas de Lágrima Negra`:** Lógica e Ciências — astronomia e declinação solar para ler microinscrições sob o zênite do meio-dia.
