extends Node

signal entry_unlocked(entry_id: String)
signal concept_mastered(concept_id: String)

const CODEX_DIR: String = "res://data/codex/"

var loaded_entries: Dictionary = {}
var unlocked_entry_ids: Array = []

func _ready() -> void:
	load_all_codex_data()

func load_all_codex_data() -> void:
	var dir = DirAccess.open(CODEX_DIR)
	if not dir:
		print("[CodiceManager] Diretorio data/codex/ sera criado com as primeiras entradas.")
		return
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".json"):
			var file_path = CODEX_DIR + file_name
			var file = FileAccess.open(file_path, FileAccess.READ)
			if file:
				var json_str = file.get_as_text()
				file.close()
				var parsed = JSON.parse_string(json_str)
				if parsed and typeof(parsed) == TYPE_DICTIONARY and parsed.has("id"):
					loaded_entries[parsed["id"]] = parsed
		file_name = dir.get_next()
	
	print("[CodiceManager] Carregados %d verbetes do Codice do Conhecimento." % loaded_entries.size())

func unlock_entry(entry_id: String) -> void:
	if not unlocked_entry_ids.has(entry_id):
		unlocked_entry_ids.append(entry_id)
		print("[CodiceManager] Novo verbete desbloqueado: %s" % entry_id)
		emit_signal("entry_unlocked", entry_id)
		
		# Salva automaticamente no SaveSystem
		if SaveSystem.current_save_data.has("codice"):
			if not SaveSystem.current_save_data["codice"]["unlocked_entries"].has(entry_id):
				SaveSystem.current_save_data["codice"]["unlocked_entries"].append(entry_id)
				SaveSystem.save_game()

func is_entry_unlocked(entry_id: String) -> bool:
	return unlocked_entry_ids.has(entry_id)

func get_entries_by_area(area_name: String) -> Array[Dictionary]:
	var results: Array[Dictionary] = []
	for id in loaded_entries.keys():
		var entry = loaded_entries[id]
		if entry.get("educational_area", "") == area_name:
			results.append(entry)
	return results

func get_entry(entry_id: String) -> Dictionary:
	return loaded_entries.get(entry_id, {})
