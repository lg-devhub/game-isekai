extends Node

signal puzzle_loaded(puzzle_data: Dictionary)
signal puzzle_solved(puzzle_id: String, rewards: Dictionary)
signal puzzle_attempt_failed(diagnostic_text: String)
signal hint_revealed(level: int, hint_text: String, cost: int)

const PUZZLE_DATA_DIR: String = "res://data/puzzles/"

const MathValidator = preload("res://scripts/puzzle/validators/math_validator.gd")
const LogicValidator = preload("res://scripts/puzzle/validators/logic_validator.gd")
const LanguageValidator = preload("res://scripts/puzzle/validators/language_validator.gd")
const ScienceValidator = preload("res://scripts/puzzle/validators/science_validator.gd")


var current_puzzle_data: Dictionary = {}
var current_hints_unlocked: int = 0
var current_attempts: int = 0
var start_time_seconds: int = 0

func _ready() -> void:
	print("[PuzzleEngine] Motor de Quebra-Cabecas Educativos pronto.")

func load_puzzle(puzzle_id: String) -> bool:
	var file_path = PUZZLE_DATA_DIR + puzzle_id.to_upper() + ".json"
	if not FileAccess.file_exists(file_path):
		# Tenta com minúsculas se falhar
		file_path = PUZZLE_DATA_DIR + puzzle_id.to_lower() + ".json"
	
	if not FileAccess.file_exists(file_path):
		push_error("[PuzzleEngine] Arquivo de puzzle nao encontrado em: %s" % file_path)
		return false
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		return false
	
	var json_str = file.get_as_text()
	file.close()
	
	var parsed = JSON.parse_string(json_str)
	if not parsed or typeof(parsed) != TYPE_DICTIONARY:
		push_error("[PuzzleEngine] Falha ao processar JSON do puzzle: %s" % puzzle_id)
		return false
	
	current_puzzle_data = parsed
	current_hints_unlocked = 0
	current_attempts = 0
	start_time_seconds = int(Time.get_unix_time_from_system())
	
	print("[PuzzleEngine] Puzzle carregado com sucesso: %s (%s - Nivel %d)" % [
		current_puzzle_data.get("title", ""),
		current_puzzle_data.get("educational_area", ""),
		current_puzzle_data.get("difficulty", 1)
	])
	
	emit_signal("puzzle_loaded", current_puzzle_data)
	return true

func submit_answer(user_input: Variant) -> bool:
	if current_puzzle_data.is_empty():
		return false
	
	current_attempts += 1
	var area = current_puzzle_data.get("educational_area", "MATHEMATICS").to_upper()
	var result: Dictionary = {"is_correct": false, "diagnostic": ""}
	
	match area:
		"MATHEMATICS", "MATEMÁTICA", "MATEMATICA":
			result = MathValidator.validate(user_input, current_puzzle_data)
		"LOGIC", "LÓGICA E PENSAMENTO CRÍTICO", "LOGICA":
			result = LogicValidator.validate(user_input, current_puzzle_data)
		"LANGUAGE", "LINGUAGEM E INTERPRETAÇÃO", "LINGUAGEM":
			result = LanguageValidator.validate(user_input, current_puzzle_data)
		"SCIENCES", "CIÊNCIAS DA NATUREZA", "CIENCIAS":
			result = ScienceValidator.validate(user_input, current_puzzle_data)
		_:
			result = MathValidator.validate(user_input, current_puzzle_data)
	
	if result["is_correct"]:
		AudioManager.play_sfx("SFX_PUZZLE_SUCCESS")
		_handle_solution_success()
		return true
	else:
		AudioManager.play_sfx("SFX_PUZZLE_ERROR")
		emit_signal("puzzle_attempt_failed", result.get("diagnostic", "Tente novamente."))
		return false

func request_hint(target_level: int) -> String:
	if current_puzzle_data.is_empty():
		return ""
	
	var hints: Array = current_puzzle_data.get("hints", [])
	if target_level <= 0 or target_level > hints.size():
		return ""
	
	var hint_data: Dictionary = hints[target_level - 1]
	var cost: int = hint_data.get("cost_lumis", 0)
	var text: String = hint_data.get("text", "")
	
	if target_level > current_hints_unlocked:
		current_hints_unlocked = target_level
	
	AudioManager.play_sfx("SFX_PAGE_TURN")
	emit_signal("hint_revealed", target_level, text, cost)
	return text

func _handle_solution_success() -> void:
	var puzzle_id = current_puzzle_data.get("id", "")
	var rewards = current_puzzle_data.get("rewards", {"erudition_xp": 50, "lumis": 25})
	
	# Desbloqueia entrada no Códice se houver
	var codex_id = rewards.get("codex_entry_id", "")
	if codex_id != "":
		CodiceManager.unlock_entry(codex_id)
	
	# Atualiza registro de progresso no save local
	if SaveSystem.current_save_data.has("puzzles"):
		SaveSystem.current_save_data["puzzles"][puzzle_id] = {
			"solved": true,
			"hints_used": current_hints_unlocked,
			"attempts_count": current_attempts,
			"solved_timestamp": int(Time.get_unix_time_from_system())
		}
	
	# Adiciona moedas e XP
	if SaveSystem.current_save_data.has("economy"):
		SaveSystem.current_save_data["economy"]["lumis"] += rewards.get("lumis", 0)
	
	# Concede XP e Maestria via ProgressionManager
	var difficulty: int = current_puzzle_data.get("difficulty", 1)
	var area: String = current_puzzle_data.get("educational_area", "matematica")
	ProgressionManager.award_puzzle_xp(difficulty, area, current_hints_unlocked)
	
	SaveSystem.save_game()
	
	print("[PuzzleEngine] Enigma resolvido com sucesso! XP concedido via ProgressionManager | Lumis: +%d" % [
		rewards.get("lumis", 0)
	])
	
	emit_signal("puzzle_solved", puzzle_id, rewards)

