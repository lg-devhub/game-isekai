# PUZZLE-CONTENT-SCHEMA — Esquema Estruturado de Dados de Puzzles Pedagógicos

Este documento define a especificação JSON Schema formal para armazenamento, validação e carregamento offline de todos os quebra-cabeças educativos em **Echoes of the Veil**.

---

## 1. Princípio do Desacoplamento e Validação Pedagógica

Todos os quebra-cabeças residem em arquivos de dados externos (`data/puzzles/*.json`) e são carregados dinamicamente pelo `PuzzleEngine`. Cada arquivo inclui os metadados pedagógicos necessários para a exibição de feedback diagnóstico e alimentação do *Códice do Conhecimento*.

---

## 2. Esquema JSON Canônico

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "EducationalPuzzleContent",
  "type": "object",
  "required": [
    "id",
    "title",
    "educational_area",
    "subcategory",
    "target_skill",
    "prior_knowledge",
    "difficulty",
    "chapter",
    "narrative_context",
    "prompt",
    "data_and_constraints",
    "input_type",
    "solution",
    "step_by_step_explanation",
    "common_errors",
    "hints",
    "transfer_example",
    "rewards",
    "validation_criteria"
  ],
  "properties": {
    "id": {
      "type": "string",
      "description": "Identificador único (ex: PUZ_MATH_001_CALIBRACAO_ANIS)"
    },
    "title": {
      "type": "string",
      "description": "Título diegético do enigma exibido na interface"
    },
    "educational_area": {
      "type": "string",
      "enum": ["MATHEMATICS", "LOGIC", "LANGUAGE", "SCIENCES", "INTERDISCIPLINARY"]
    },
    "subcategory": {
      "type": "string",
      "description": "Subcategoria pedagógica (ex: MATH-PRO, LOGIC-VER, SCI-MEC)"
    },
    "target_skill": {
      "type": "string",
      "description": "Habilidade ou competência específica desenvolvida pelo enigma"
    },
    "prior_knowledge": {
      "type": "array",
      "items": { "type": "string" },
      "description": "Conceitos que o jogador precisa conhecer antes do desafio"
    },
    "difficulty": {
      "type": "integer",
      "minimum": 1,
      "maximum": 5
    },
    "chapter": {
      "type": "integer",
      "minimum": 0,
      "maximum": 4
    },
    "is_mandatory": {
      "type": "boolean"
    },
    "narrative_context": {
      "type": "string",
      "description": "Contexto dramático que justifica a necessidade do enigma na história"
    },
    "prompt": {
      "type": "string",
      "description": "Enunciado oficial e dados apresentados ao jogador"
    },
    "data_and_constraints": {
      "type": "object",
      "description": "Variáveis, limites numéricos ou restrições de montagem"
    },
    "input_type": {
      "type": "string",
      "enum": [
        "NUMERIC_INPUT",
        "TEXT_INPUT",
        "MULTI_CHOICE",
        "ROTARY_DIAL",
        "SEQUENCE_ORDER",
        "GRID_SELECTOR",
        "CONNECT_NODES"
      ]
    },
    "solution": {
      "description": "A resposta exata (número, string ou array de posições)"
    },
    "step_by_step_explanation": {
      "type": "string",
      "description": "Demonstração formal passo a passo para exibição no Códice"
    },
    "accepted_answers": {
      "type": "array",
      "items": { "type": "string" }
    },
    "common_errors": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["pattern", "feedback"],
        "properties": {
          "pattern": { "type": "string" },
          "feedback": { "type": "string" }
        }
      }
    },
    "hints": {
      "type": "array",
      "minItems": 3,
      "maxItems": 3,
      "items": {
        "type": "object",
        "required": ["level", "cost_lumis", "text"],
        "properties": {
          "level": { "type": "integer", "enum": [1, 2, 3] },
          "cost_lumis": { "type": "integer" },
          "text": { "type": "string" }
        }
      }
    },
    "transfer_example": {
      "type": "string",
      "description": "Exemplo prático de aplicação do conceito em outra situação ou no mundo real"
    },
    "rewards": {
      "type": "object",
      "required": ["erudition_xp", "lumis"],
      "properties": {
        "erudition_xp": { "type": "integer" },
        "lumis": { "type": "integer" },
        "salt_prisms": { "type": "integer" },
        "codex_entry_id": { "type": "string" }
      }
    },
    "prerequisites": {
      "type": "array",
      "items": { "type": "string" }
    },
    "validation_criteria": {
      "type": "string",
      "description": "Regra matemática ou lógica que comprova o fechamento sem ambiguidade"
    }
  }
}
```
