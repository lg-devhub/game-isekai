## QuestManager — Autoload Singleton
## Gerencia o estado de quests (investigativas, pedagógicas e de exploração).
## Carrega definições de data/quests/*.json e sincroniza com SaveSystem.
extends Node


# ---------------------------------------------------------------------------
# Sinais
# ---------------------------------------------------------------------------
signal quest_started(quest_id: String)
signal quest_stage_advanced(quest_id: String, stage_index: int)
signal quest_objective_completed(quest_id: String, objective_id: String)
signal quest_completed(quest_id: String)
signal quest_failed(quest_id: String)

# ---------------------------------------------------------------------------
# Enumerações
# ---------------------------------------------------------------------------
enum QuestState {
	NOT_STARTED,
	ACTIVE,
	COMPLETED,
	FAILED
}

# ---------------------------------------------------------------------------
# Constantes
# ---------------------------------------------------------------------------
const QUEST_DATA_DIR := "res://data/quests/"

# ---------------------------------------------------------------------------
# Estado interno
# ---------------------------------------------------------------------------
## Definições brutas carregadas dos JSONs: { quest_id: Dictionary }
var _definitions: Dictionary = {}

## Estado em tempo de execução (sincroniza com SaveSystem)
## { quest_id: { "state": QuestState, "stage": int, "objectives": { obj_id: bool } } }
var _runtime: Dictionary = {}

# ---------------------------------------------------------------------------
# Ciclo de vida
# ---------------------------------------------------------------------------
func _ready() -> void:
	_load_all_definitions()
	_sync_from_save()
	call_deferred("_connect_puzzle_engine")


## Carrega todos os arquivos JSON da pasta de quests
func _load_all_definitions() -> void:
	var dir := DirAccess.open(QUEST_DATA_DIR)
	if dir == null:
		push_warning("QuestManager: diretório '%s' não encontrado." % QUEST_DATA_DIR)
		return

	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".json"):
			_load_quest_file(QUEST_DATA_DIR + file_name)
		file_name = dir.get_next()
	dir.list_dir_end()


func _load_quest_file(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_warning("QuestManager: não foi possível abrir '%s'." % path)
		return

	var json := JSON.new()
	var err := json.parse(file.get_as_text())
	file.close()

	if err != OK:
		push_warning("QuestManager: JSON inválido em '%s'." % path)
		return

	var data: Dictionary = json.get_data()
	var quest_id: String = data.get("id", "")
	if quest_id == "":
		push_warning("QuestManager: quest sem 'id' em '%s'." % path)
		return

	_definitions[quest_id] = data



func _connect_puzzle_engine() -> void:
	var pe := get_node_or_null("/root/PuzzleEngine")
	if pe and pe.has_signal("puzzle_solved"):
		pe.puzzle_solved.connect(_on_puzzle_solved)


func _on_puzzle_solved(puzzle_id: String, _rewards: Dictionary) -> void:
	for quest_id in get_quests_by_state(QuestState.ACTIVE):
		var definition: Dictionary = _definitions.get(quest_id, {})
		for obj in definition.get("objectives", []):
			if obj.get("type", "") == "puzzle" and obj.get("puzzle_id", "").to_upper() == puzzle_id.to_upper():
				var obj_id: String = obj.get("id", "")
				if not is_objective_done(quest_id, obj_id):
					complete_objective(quest_id, obj_id)
					print("[QuestManager] Objetivo de enigma '%s' cumprido para a quest '%s'." % [obj_id, quest_id])


## Restaura o estado de runtime a partir do save carregado
func _sync_from_save() -> void:
	var saved: Dictionary = SaveSystem.current_save_data.get("quests", {})
	for quest_id in _definitions:
		if saved.has(quest_id) and typeof(saved[quest_id]) == TYPE_DICTIONARY:
			_runtime[quest_id] = saved[quest_id].duplicate(true)
		else:
			_runtime[quest_id] = _default_runtime(quest_id)
			if saved.has("active_quests") and typeof(saved["active_quests"]) == TYPE_ARRAY and quest_id in saved["active_quests"]:
				_runtime[quest_id]["state"] = QuestState.ACTIVE


func _default_runtime(quest_id: String) -> Dictionary:
	var definition: Dictionary = _definitions.get(quest_id, {})
	var objectives: Dictionary = {}
	for obj in definition.get("objectives", []):
		var obj_id: String = obj.get("id", "")
		if obj_id != "":
			objectives[obj_id] = false
	return {
		"state": QuestState.NOT_STARTED,
		"stage": 0,
		"objectives": objectives
	}


# ---------------------------------------------------------------------------
# API Pública
# ---------------------------------------------------------------------------

## Retorna o estado atual de uma quest
func get_state(quest_id: String) -> QuestState:
	return _runtime.get(quest_id, {}).get("state", QuestState.NOT_STARTED)


## Retorna verdadeiro se a quest está ativa
func is_active(quest_id: String) -> bool:
	return get_state(quest_id) == QuestState.ACTIVE


## Retorna verdadeiro se a quest foi concluída
func is_completed(quest_id: String) -> bool:
	return get_state(quest_id) == QuestState.COMPLETED


## Inicia uma quest que ainda não foi iniciada
func start_quest(quest_id: String) -> bool:
	if not _definitions.has(quest_id):
		push_warning("QuestManager: quest '%s' não encontrada." % quest_id)
		return false

	if get_state(quest_id) != QuestState.NOT_STARTED:
		return false

	_runtime[quest_id]["state"] = QuestState.ACTIVE
	_runtime[quest_id]["stage"] = 0
	_persist()
	quest_started.emit(quest_id)
	return true


## Avança para o próximo estágio de uma quest ativa
func advance_stage(quest_id: String) -> bool:
	if not is_active(quest_id):
		return false

	var definition: Dictionary = _definitions.get(quest_id, {})
	var stages: Array = definition.get("stages", [])
	var current_stage: int = _runtime[quest_id]["stage"]
	var next_stage: int = current_stage + 1

	if next_stage >= stages.size():
		# Não há mais estágios: quest concluída automaticamente se todos os objetivos estiverem completos
		return complete_quest(quest_id)

	_runtime[quest_id]["stage"] = next_stage
	_persist()
	quest_stage_advanced.emit(quest_id, next_stage)
	return true


## Marca um objetivo individual como concluído
func complete_objective(quest_id: String, objective_id: String) -> bool:
	if not is_active(quest_id):
		return false

	if not _runtime[quest_id]["objectives"].has(objective_id):
		push_warning("QuestManager: objetivo '%s' não existe em '%s'." % [objective_id, quest_id])
		return false

	_runtime[quest_id]["objectives"][objective_id] = true
	_persist()
	quest_objective_completed.emit(quest_id, objective_id)

	# Verifica se todos os objetivos do estágio atual foram concluídos
	_check_stage_auto_advance(quest_id)
	return true


## Marca a quest como concluída e distribui recompensas
func complete_quest(quest_id: String) -> bool:
	if get_state(quest_id) == QuestState.COMPLETED:
		return false

	_runtime[quest_id]["state"] = QuestState.COMPLETED
	
	var def: Dictionary = _definitions.get(quest_id, {})
	var rewards: Dictionary = def.get("rewards", {})
	
	# Lúmis
	if rewards.has("lumis") and SaveSystem.current_save_data.has("economy"):
		SaveSystem.current_save_data["economy"]["lumis"] += rewards.get("lumis", 0)
	
	# XP de Erudição
	if rewards.has("xp"):
		var pm := get_node_or_null("/root/ProgressionManager")
		if pm:
			pm.add_xp(rewards.get("xp", 0))
	
	# Itens e Documentos Forenses
	if rewards.has("items"):
		var im := get_node_or_null("/root/InventoryManager")
		if im:
			for item_id in rewards.get("items", []):
				if item_id.begins_with("FOR_DOC_"):
					im.add_forensic_document(item_id)
				else:
					im.add_item(item_id, 1)
	
	# Entradas do Códice
	if rewards.has("codex_entries"):
		var cm := get_node_or_null("/root/CodiceManager")
		if cm:
			for cod_id in rewards.get("codex_entries", []):
				cm.unlock_entry(cod_id)
	
	# Inicia próxima quest se definida
	var next_q: String = def.get("next_quest", "")
	if next_q != "":
		start_quest(next_q)
	
	_persist()
	quest_completed.emit(quest_id)
	print("[QuestManager] Quest '%s' concluída com sucesso! Recompensas concedidas." % quest_id)
	return true



## Marca a quest como falhada
func fail_quest(quest_id: String) -> bool:
	if get_state(quest_id) in [QuestState.COMPLETED, QuestState.FAILED]:
		return false

	_runtime[quest_id]["state"] = QuestState.FAILED
	_persist()
	quest_failed.emit(quest_id)
	return true


## Retorna o estágio atual de uma quest
func get_current_stage(quest_id: String) -> int:
	return _runtime.get(quest_id, {}).get("stage", 0)


## Retorna a definição de um estágio específico
func get_stage_data(quest_id: String, stage_index: int) -> Dictionary:
	var stages: Array = _definitions.get(quest_id, {}).get("stages", [])
	if stage_index < stages.size():
		return stages[stage_index]
	return {}


## Retorna todos os IDs de quests em determinado estado
func get_quests_by_state(state: QuestState) -> Array[String]:
	var result: Array[String] = []
	for quest_id in _runtime:
		if _runtime[quest_id].get("state", QuestState.NOT_STARTED) == state:
			result.append(quest_id)
	return result


## Retorna verdadeiro se o objetivo específico já foi concluído
func is_objective_done(quest_id: String, objective_id: String) -> bool:
	return _runtime.get(quest_id, {}).get("objectives", {}).get(objective_id, false)


## Retorna a descrição localizada da quest
func get_quest_title(quest_id: String) -> String:
	return _definitions.get(quest_id, {}).get("title", quest_id)


## Retorna o resumo do estágio atual da quest
func get_current_stage_description(quest_id: String) -> String:
	var stage_index := get_current_stage(quest_id)
	return get_stage_data(quest_id, stage_index).get("description", "")

# ---------------------------------------------------------------------------
# Internos
# ---------------------------------------------------------------------------

## Verifica se todos os objetivos obrigatórios do estágio atual foram concluídos
## e, se sim, avança automaticamente o estágio.
func _check_stage_auto_advance(quest_id: String) -> void:
	var definition: Dictionary = _definitions.get(quest_id, {})
	var stages: Array = definition.get("stages", [])
	var current_stage: int = _runtime[quest_id]["stage"]

	if current_stage >= stages.size():
		return

	var stage_data: Dictionary = stages[current_stage]
	var required_objectives: Array = stage_data.get("required_objectives", [])

	if required_objectives.is_empty():
		return

	var all_done := true
	for obj_id in required_objectives:
		if not _runtime[quest_id]["objectives"].get(obj_id, false):
			all_done = false
			break

	if all_done:
		advance_stage(quest_id)


## Persiste o estado de runtime de volta ao SaveSystem
func _persist() -> void:
	SaveSystem.current_save_data["quests"] = {}
	for quest_id in _runtime:
		SaveSystem.current_save_data["quests"][quest_id] = _runtime[quest_id].duplicate(true)
	SaveSystem.save_game()
