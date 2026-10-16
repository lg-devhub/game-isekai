## DialogueManager — Autoload Singleton
## Gerencia sistemas de diálogo narrativo, escolhas ramificadas,
## testes de conhecimento e ativação de eventos/enigmas/quests.
extends Node

# ---------------------------------------------------------------------------
# Sinais
# ---------------------------------------------------------------------------
signal dialogue_started(dialogue_id: String)
signal node_displayed(node_data: Dictionary)
signal choices_presented(choices: Array)
signal dialogue_ended(dialogue_id: String)

# ---------------------------------------------------------------------------
# Constantes
# ---------------------------------------------------------------------------
const DIALOGUE_DATA_DIR := "res://data/dialogues/"

# ---------------------------------------------------------------------------
# Estado interno
# ---------------------------------------------------------------------------
var _current_dialogue: Dictionary = {}
var _current_node_id: String = ""
var _dialogue_active: bool = false

# ---------------------------------------------------------------------------
# API Pública
# ---------------------------------------------------------------------------

## Carrega e inicia um diálogo pelo ID
func start_dialogue(dialogue_id: String, start_node_id: String = "start") -> bool:
	var path := DIALOGUE_DATA_DIR + dialogue_id + ".json"
	if not FileAccess.file_exists(path):
		path = DIALOGUE_DATA_DIR + dialogue_id.to_upper() + ".json"
	
	if not FileAccess.file_exists(path):
		push_warning("[DialogueManager] Arquivo de diálogo não encontrado: %s" % path)
		return false
	
	var file := FileAccess.open(path, FileAccess.READ)
	if not file:
		return false
	
	var json_str := file.get_as_text()
	file.close()
	
	var parsed: Variant = JSON.parse_string(json_str)
	if not (parsed is Dictionary):
		push_warning("[DialogueManager] JSON inválido em: %s" % path)
		return false
	
	_current_dialogue = parsed
	_current_node_id = start_node_id
	_dialogue_active = true
	
	dialogue_started.emit(dialogue_id)
	_display_current_node()
	return true


## Avança para o próximo nó do diálogo (quando não há escolhas múltiplas)
func advance() -> void:
	if not _dialogue_active or _current_dialogue.is_empty():
		return
	
	var nodes: Dictionary = _current_dialogue.get("nodes", {})
	var current_node: Dictionary = nodes.get(_current_node_id, {})
	
	# Se houver opções de escolha, o avanço deve ocorrer via select_choice
	var choices: Array = current_node.get("choices", [])
	if not choices.is_empty():
		return
	
	var next_node_id: String = current_node.get("next", "")
	if next_node_id != "" and nodes.has(next_node_id):
		_current_node_id = next_node_id
		_display_current_node()
	else:
		end_dialogue()


## Seleciona uma opção de escolha pelo índice
func select_choice(choice_index: int) -> void:
	if not _dialogue_active or _current_dialogue.is_empty():
		return
	
	var nodes: Dictionary = _current_dialogue.get("nodes", {})
	var current_node: Dictionary = nodes.get(_current_node_id, {})
	var choices: Array = current_node.get("choices", [])
	
	if choice_index < 0 or choice_index >= choices.size():
		return
	
	var choice: Dictionary = choices[choice_index]
	
	# Aplica flags narrativas se houver
	if choice.has("set_flag"):
		var flag_key: String = choice["set_flag"]
		set_narrative_flag(flag_key, true)
	
	# Aciona enigma se indicado
	if choice.has("trigger_puzzle"):
		var puz_id: String = choice["trigger_puzzle"]
		PuzzleEngine.load_puzzle(puz_id)
		SceneManager.change_scene("res://scenes/puzzle/PuzzleView.tscn")
		end_dialogue()
		return
	
	var next_node_id: String = choice.get("next", "")
	if next_node_id != "" and nodes.has(next_node_id):
		_current_node_id = next_node_id
		_display_current_node()
	else:
		end_dialogue()


## Encerra o diálogo atual
func end_dialogue() -> void:
	var dia_id: String = _current_dialogue.get("id", "")
	_dialogue_active = false
	_current_dialogue = {}
	_current_node_id = ""
	dialogue_ended.emit(dia_id)


## Retorna se há um diálogo em andamento
func is_active() -> bool:
	return _dialogue_active


## Retorna o nó atual de diálogo
func get_current_node() -> Dictionary:
	var nodes: Dictionary = _current_dialogue.get("nodes", {})
	return nodes.get(_current_node_id, {})

# ---------------------------------------------------------------------------
# Flags Narrativas
# ---------------------------------------------------------------------------

func set_narrative_flag(flag_key: String, value: Variant = true) -> void:
	if not SaveSystem.current_save_data.has("narrative_flags"):
		SaveSystem.current_save_data["narrative_flags"] = {}
	SaveSystem.current_save_data["narrative_flags"][flag_key] = value
	SaveSystem.save_game()


func get_narrative_flag(flag_key: String, default_value: Variant = false) -> Variant:
	if SaveSystem.current_save_data.has("narrative_flags"):
		return SaveSystem.current_save_data["narrative_flags"].get(flag_key, default_value)
	return default_value

# ---------------------------------------------------------------------------
# Internos
# ---------------------------------------------------------------------------

func _display_current_node() -> void:
	var nodes: Dictionary = _current_dialogue.get("nodes", {})
	var current_node: Dictionary = nodes.get(_current_node_id, {})
	
	if current_node.is_empty():
		end_dialogue()
		return
	
	# Processa trigger de evento se houver
	if current_node.has("trigger_quest"):
		var q_id: String = current_node["trigger_quest"]
		QuestManager.start_quest(q_id)
	
	node_displayed.emit(current_node)
	
	var choices: Array = current_node.get("choices", [])
	if not choices.is_empty():
		# Filtra escolhas condicionais
		var visible_choices: Array = []
		for c in choices:
			if _check_choice_condition(c):
				visible_choices.append(c)
		choices_presented.emit(visible_choices)


func _check_choice_condition(choice: Dictionary) -> bool:
	if choice.has("requires_flag"):
		if not bool(get_narrative_flag(choice["requires_flag"], false)):
			return false
	if choice.has("requires_codex"):
		if not CodiceManager.is_entry_unlocked(choice["requires_codex"]):
			return false
	if choice.has("requires_item"):
		if not InventoryManager.has_item(choice["requires_item"]):
			return false
	return true
