extends Node

signal save_started(slot_id: int)
signal save_completed(slot_id: int, success: bool)
signal save_loaded(slot_id: int, success: bool)

const SAVE_DIR: String = "user://saves/"
const CURRENT_SAVE_VERSION: int = 2

var current_save_data: Dictionary = {}

func _ready() -> void:
	ensure_save_directory_exists()

func ensure_save_directory_exists() -> void:
	var dir = DirAccess.open("user://")
	if dir and not dir.dir_exists("saves"):
		dir.make_dir("saves")

func get_default_save_data() -> Dictionary:
	return {
		"save_version": CURRENT_SAVE_VERSION,
		"timestamp": int(Time.get_unix_time_from_system()),
		"playtime_seconds": 0,
		"current_chapter": 0,
		"current_location_id": "LOC_BLUE_GLASS_CRATER",
		"protagonist": {
			"name": "Arthur",
			"pronoun": "HE_HIM",
			"skin_tone": 1,
			"hair_style": "DEFAULT",
			"current_outfit_id": "OUTFIT_RESEARCHER_TRAVEL"
		},
		"progression": {
			"erudition_level": 1,
			"erudition_xp": 0,
			"insight_points_available": 0,
			"mastery_title": "Aprendiz Inexperiente"
		},
		"economy": {
			"lumis": 50,
			"salt_prisms": 0,
			"total_lumis_earned": 50,
			"total_lumis_spent": 0
		},
		"inventory": {
			"items": {
				"ITEM_DIARIO_DE_CAMPO": 1,
				"ITEM_DICA_EXTRA": 2
			},
			"forensic_documents": ["FOR_DOC_REGISTRO_AGRIMENSOR"],
			"forensic_docs": ["FOR_DOC_REGISTRO_AGRIMENSOR"]
		},
		"quests": {
			"active_quests": ["QP_PROLOGO_01"],
			"completed_quests": [],
			"quest_stages_progress": {}
		},
		"puzzles": {},
		"codice": {
			"unlocked_entries": [],
			"mastered_concepts": [],
			"spaced_reviews_completed": 0,
			"voluntary_revision_scores": {}
		},
		"customization": {
			"skin": "skin_03_medio",
			"hair_style": "hair_style_01_curto",
			"hair_color": "hair_color_preto",
			"outfit": "outfit_viajante_basico"
		},
		"narrative_flags": {}
	}

func reset_save(slot_id: int = 1) -> bool:
	current_save_data = get_default_save_data()
	var success = save_game(slot_id)
	print("[SaveSystem] Slot %d redefinido para os valores de fabrica." % slot_id)
	return success


func save_game(slot_id: int = 1) -> bool:
	emit_signal("save_started", slot_id)
	ensure_save_directory_exists()
	
	var base_path = SAVE_DIR + "slot_%d.json" % slot_id
	var tmp_path = base_path + ".tmp"
	var bak_path = base_path + ".bak"
	
	if current_save_data.is_empty():
		current_save_data = get_default_save_data()
	
	current_save_data["timestamp"] = int(Time.get_unix_time_from_system())
	
	var json_string = JSON.stringify(current_save_data, "\t")
	var checksum = json_string.sha256_text()
	
	var payload = {
		"data": current_save_data,
		"_metadata": {
			"checksum": checksum,
			"schema_version": CURRENT_SAVE_VERSION
		}
	}
	
	var final_json = JSON.stringify(payload, "\t")
	
	var file = FileAccess.open(tmp_path, FileAccess.WRITE)
	if not file:
		push_error("[SaveSystem] Nao foi possivel criar arquivo temporario de save: %s" % tmp_path)
		emit_signal("save_completed", slot_id, false)
		return false
	
	file.store_string(final_json)
	file.close()
	
	if FileAccess.file_exists(base_path):
		var dir = DirAccess.open(SAVE_DIR)
		if dir:
			if FileAccess.file_exists(bak_path):
				dir.remove(bak_path.get_file())
			dir.copy(base_path.get_file(), bak_path.get_file())
	
	var dir = DirAccess.open(SAVE_DIR)
	if dir:
		dir.rename(tmp_path.get_file(), base_path.get_file())
	
	print("[SaveSystem] Jogo salvo com sucesso localmente no Slot %d (Operacao Atomica)." % slot_id)
	emit_signal("save_completed", slot_id, true)
	return true

func load_game(slot_id: int = 1) -> bool:
	var base_path = SAVE_DIR + "slot_%d.json" % slot_id
	var bak_path = base_path + ".bak"
	
	var path_to_load = base_path
	if not FileAccess.file_exists(base_path):
		if FileAccess.file_exists(bak_path):
			print("[SaveSystem] Save primario ausente. Tentando recuperar backup...")
			path_to_load = bak_path
		else:
			print("[SaveSystem] Nenhum save anterior encontrado. Criando novo perfil...")
			current_save_data = get_default_save_data()
			save_game(slot_id)
			emit_signal("save_loaded", slot_id, true)
			return true
	
	var file = FileAccess.open(path_to_load, FileAccess.READ)
	if not file:
		emit_signal("save_loaded", slot_id, false)
		return false
	
	var content = file.get_as_text()
	file.close()
	
	var parsed = JSON.parse_string(content)
	if not parsed or typeof(parsed) != TYPE_DICTIONARY:
		push_error("[SaveSystem] Arquivo de save corrompido em: %s" % path_to_load)
		emit_signal("save_loaded", slot_id, false)
		return false
	
	if parsed.has("data"):
		current_save_data = parsed["data"]
	else:
		current_save_data = parsed
	
	print("[SaveSystem] Progresso do jogador carregado com sucesso (Slot %d)." % slot_id)
	emit_signal("save_loaded", slot_id, true)
	return true
