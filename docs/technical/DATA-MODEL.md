# DATA-MODEL — Modelagem Formal de Dados do Projeto

Este documento define os modelos de dados, esquemas relacionais, estruturas JSON e definições de classes de dados em GDScript para o gerenciamento de estados de jogo, inventário, personagens, quests, quebra-cabeças educativos e o *Códice do Conhecimento* ([`PUZZLE-CONTENT-SCHEMA.md`](file:///c:/Users/ogust/Desktop/game-isekai/docs/puzzles/PUZZLE-CONTENT-SCHEMA.md)).

---

## 1. Visão Geral das Entidades de Dados

```
┌─────────────────┐       1:1       ┌─────────────────┐
│   PlayerSave    ├─────────────────┤  Protagonist    │
└────────┬────────┘                 └─────────────────┘
         │
         ├── 1:1 ──► [ ProgressionState ] (Nível, XP, Título de Erudição)
         ├── 1:1 ──► [ EconomyState ] (Lúmis, Prismas, Histórico)
         ├── 1:1 ──► [ InventoryState ] (Itens, Reagentes, Documentos Forenses)
         ├── 1:N ──► [ QuestProgressRecord ] (Status de quests e objetivos de aprendizagem)
         ├── 1:N ──► [ PuzzleProgressRecord ] (Resolvido, Dicas, Tentativas, Diagnóstico)
         ├── 1:N ──► [ CodiceKnowledgeRecord ] (Verbetes desbloqueados, Exemplos, Revisões)
         └── 1:N ──► [ NarrativeWorldFlags ] (Decisões éticas e marcos de lore)
```

---

## 2. Estrutura do Estado Global de Salvamento (`PlayerSaveData`)

Representação serializada do arquivo de save local do jogador (`user://saves/slot_1.json`):

```json
{
  "save_version": 2,
  "timestamp": 1729012345,
  "playtime_seconds": 7420,
  "current_chapter": 1,
  "current_location_id": "LOC_VAL_SERENA_MARKET",
  
  "protagonist": {
    "name": "Arthur",
    "pronoun": "HE_HIM",
    "skin_tone": 2,
    "hair_style": "SHORT_WAVY",
    "hair_color": "DARK_BROWN",
    "eye_color": "AMBER",
    "current_outfit_id": "OUTFIT_VAL_SERENA_LINEN",
    "current_accessory_id": "ACC_PRISMATIC_MONOCLE"
  },
  
  "progression": {
    "erudition_level": 3,
    "erudition_xp": 950,
    "insight_points_available": 1,
    "unlocked_perks": [
      "PERK_CALM_MIND_HINT_DISCOUNT",
      "PERK_FORENSIC_OBSERVATION_ZOOM"
    ],
    "mastery_title": "Pesquisador Assistente"
  },
  
  "economy": {
    "lumis": 340,
    "salt_prisms": 3,
    "total_lumis_earned": 820,
    "total_lumis_spent": 480
  },
  
  "inventory": {
    "items": [
      { "item_id": "ITEM_TISANA_ESTABILIZADORA", "quantity": 2 },
      { "item_id": "ITEM_FRASCO_SULFATO", "quantity": 1 },
      { "item_id": "ITEM_LUPA_QUARTZO", "quantity": 1 }
    ],
    "forensic_documents": [
      {
        "doc_id": "DOC_PENA_FERRO_MANCHADA",
        "inspected_details": ["OXIDATION_PINHO", "FAMILY_CREST_CASSIA"]
      }
    ]
  },
  
  "quests": {
    "active_quests": ["QP_03_AUDITORIA_ARQUIVO"],
    "completed_quests": ["QP_01_RESPIRACAO_VIDRO", "QP_02_ABRIGO_AGRIMENSOR"],
    "quest_stages_progress": {
      "QP_03_AUDITORIA_ARQUIVO": {
        "current_stage": 2,
        "completed_learning_objectives": ["CALCULATED_EXPORT_RATIOS"]
      }
    }
  },
  
  "puzzles": {
    "PUZ_MATH_001": {
      "solved": true,
      "educational_area": "MATHEMATICS",
      "hints_used": 0,
      "attempts_count": 1,
      "time_spent_seconds": 45,
      "solved_timestamp": 1729010000
    },
    "PUZ_SCI_001": {
      "solved": true,
      "educational_area": "SCIENCES",
      "hints_used": 1,
      "attempts_count": 2,
      "time_spent_seconds": 120,
      "solved_timestamp": 1729011200
    }
  },
  
  "codice": {
    "unlocked_entries": [
      "COD_MATH_001",
      "COD_SCI_001",
      "COD_LOG_001"
    ],
    "mastered_concepts": ["RAZOES_E_PROPORCOES", "ALAVANCAS_INTERFIXAS"],
    "spaced_reviews_completed": 4,
    "voluntary_revision_scores": {
      "COD_MATH_001_REV_1": 100
    }
  },
  
  "narrative_flags": {
    "MET_LYRA": true,
    "SAVED_RENARD_APOTHECARY": true,
    "TALOS_4_AWAKENED": false
  }
}
```

---

## 3. Modelo de Configurações do Jogador (`SettingsData`)

Serializado em arquivo de configuração nativo da Godot (`user://settings.cfg` via `ConfigFile`):

```ini
[audio]
master_volume=0.8
music_volume=0.75
sfx_volume=0.85
ambience_volume=0.70
is_muted=false

[display]
brightness_overlay=0.0
font_size_scale=1.0
colorblind_mode=0
high_contrast_text=false
reduce_motion=false

[gameplay]
puzzle_difficulty_preference=1
auto_hint_suggestions=true
text_typewriter_speed=40
auto_advance_dialogue=false
confirm_final_answers=true
language_code="pt-BR"
```

---

## 4. Classes de Recursos Tipados em GDScript (`Custom Resources`)

### Item de Inventário (`ItemResource.gd`)
```gdscript
class_name ItemResource
extends Resource

@export var id: String = ""
@export var name: String = ""
@export_multiline var description: String = ""
@export var category: String = "USABLE" # USABLE, FORENSIC, COSMETIC, KEY
@export var icon_texture_path: String = ""
@export var is_consumable: bool = false
@export var base_value_lumis: int = 10
@export var forensic_notes: Array[String] = []
```

### Entrada do Códice do Conhecimento (`CodexEntryResource.gd`)
```gdscript
class_name CodexEntryResource
extends Resource

@export var id: String = ""
@export var title: String = ""
@export var educational_area: String = "MATHEMATICS" # MATHEMATICS, LOGIC, LANGUAGE, SCIENCES
@export var subcategory: String = ""
@export var target_skill: String = ""
@export_multiline var concept_summary: String = ""
@export_multiline var formal_explanation: String = ""
@export var solved_examples: Array[Dictionary] = []
@export var voluntary_revision_puzzle_ids: Array[String] = []
@export var related_real_world_application: String = ""
@export var unlock_chapter: int = 0
```
