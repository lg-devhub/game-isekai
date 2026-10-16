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
	
	# Validação prévia de campos não preenchidos
	if user_input == null:
		AudioManager.play_sfx("SFX_PUZZLE_ERROR")
		emit_signal("puzzle_attempt_failed", "Por favor, preencha as informações solicitadas antes de verificar.")
		return false
	
	if user_input is String and user_input.strip_edges().is_empty():
		AudioManager.play_sfx("SFX_PUZZLE_ERROR")
		emit_signal("puzzle_attempt_failed", "Por favor, insira sua dedução antes de prosseguir.")
		return false
	
	if user_input is Dictionary:
		var has_empty = false
		for k in user_input.keys():
			if str(user_input[k]).strip_edges().is_empty():
				has_empty = true
				break
		if has_empty:
			AudioManager.play_sfx("SFX_PUZZLE_ERROR")
			emit_signal("puzzle_attempt_failed", "Por favor, preencha todos os campos do formulário antes de confirmar.")
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

func get_hint_cost(target_level: int) -> int:
	if current_puzzle_data.is_empty():
		return 0
	var hints: Array = current_puzzle_data.get("hints", [])
	if target_level <= 0 or target_level > hints.size():
		return 0
	if target_level <= current_hints_unlocked:
		return 0
	return hints[target_level - 1].get("cost_lumis", 0)

func is_hint_unlocked(target_level: int) -> bool:
	return target_level <= current_hints_unlocked

func request_hint(target_level: int) -> Dictionary:
	if current_puzzle_data.is_empty():
		return {"success": false, "text": "", "level": target_level, "cost": 0, "error": "Nenhum enigma carregado."}
	
	var hints: Array = current_puzzle_data.get("hints", [])
	if target_level <= 0 or target_level > hints.size():
		return {"success": false, "text": "", "level": target_level, "cost": 0, "error": "Dica indisponível para este desafio."}
	
	# Exige desbloqueio em ordem progressiva (1 -> 2 -> 3)
	if target_level > current_hints_unlocked + 1:
		return {
			"success": false,
			"text": "",
			"level": target_level,
			"cost": 0,
			"error": "Desbloqueie a Dica %d antes de consultar a Dica %d." % [current_hints_unlocked + 1, target_level]
		}
	
	var hint_data: Dictionary = hints[target_level - 1]
	var text: String = hint_data.get("text", "")
	
	# Se a dica já estiver desbloqueada, exibe gratuitamente sem descontar Lúmis
	if target_level <= current_hints_unlocked:
		AudioManager.play_sfx("SFX_PAGE_TURN")
		emit_signal("hint_revealed", target_level, text, 0)
		return {"success": true, "text": text, "level": target_level, "cost": 0, "error": ""}
	
	var cost: int = hint_data.get("cost_lumis", 0)
	var current_lumis: int = SaveSystem.current_save_data.get("economy", {}).get("lumis", 0)
	
	if current_lumis < cost:
		return {
			"success": false,
			"text": "",
			"level": target_level,
			"cost": cost,
			"error": "Lúmis insuficientes para a Dica %d (Custo: %d Lúmis | Saldo: %d Lúmis)." % [target_level, cost, current_lumis]
		}
	
	# Deduz custo de Lúmis
	if cost > 0:
		SaveSystem.current_save_data["economy"]["lumis"] -= cost
		SaveSystem.current_save_data["economy"]["total_lumis_spent"] = SaveSystem.current_save_data["economy"].get("total_lumis_spent", 0) + cost
		SaveSystem.save_game()
	
	current_hints_unlocked = target_level
	AudioManager.play_sfx("SFX_PAGE_TURN")
	emit_signal("hint_revealed", target_level, text, cost)
	return {"success": true, "text": text, "level": target_level, "cost": cost, "error": ""}

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

