## ProgressionManager — Autoload Singleton
## Gerencia o sistema de Erudição do protagonista:
##   - XP (Pontos de Erudição) ganhos ao resolver puzzles
##   - Níveis de 1 a 15 com limiares crescentes
##   - Títulos de Erudito por nível
##   - Mastery por área educativa (Matemática, Lógica, Linguagem, Ciências)
##   - Sincroniza com SaveSystem
extends Node


# ---------------------------------------------------------------------------
# Sinais
# ---------------------------------------------------------------------------
signal xp_gained(amount: int, new_total: int)
signal level_up(new_level: int, new_title: String)
signal mastery_increased(area: String, new_value: int)

# ---------------------------------------------------------------------------
# Constantes — Limiares de XP por nível
# (nível N requer XP total acumulado >= THRESHOLDS[N-1])
# ---------------------------------------------------------------------------
const THRESHOLDS: Array[int] = [
	0,       # Nível 1 (início)
	80,      # Nível 2
	200,     # Nível 3
	380,     # Nível 4
	620,     # Nível 5
	920,     # Nível 6
	1280,    # Nível 7
	1700,    # Nível 8
	2180,    # Nível 9
	2720,    # Nível 10
	3320,    # Nível 11
	3980,    # Nível 12
	4700,    # Nível 13
	5480,    # Nível 14
	6320,    # Nível 15 (máximo do protótipo)
]

const MAX_LEVEL: int = 15

## Títulos concedidos ao alcançar cada nível (índice 0 = nível 1)
const TITLES: Array[String] = [
	"Aprendiz do Véu",       # 1
	"Iniciado Perspicaz",    # 2
	"Decifrador Curioso",    # 3
	"Analista do Véu",       # 4
	"Investigador Criterioso",# 5
	"Erudito em Ascensão",   # 6
	"Guardião do Saber",     # 7
	"Arauto do Raciocínio",  # 8
	"Mestre das Hipóteses",  # 9
	"Sábio das Entrelinhas", # 10
	"Arquiteto do Método",   # 11
	"Visionário Sistêmico",  # 12
	"Testemunha da Causalidade", # 13
	"Intérprete do Cosmos",  # 14
	"Eco Além do Véu",       # 15
]

## Áreas de mastery válidas
const AREAS: Array[String] = ["matematica", "logica", "linguagem", "ciencias"]

## XP base por dificuldade do puzzle (1 a 5)
const XP_PER_DIFFICULTY: Array[int] = [10, 20, 35, 55, 80]

## Bônus de XP por nível de dica não utilizado (0 = sem dica, 1 = dica 1, etc.)
const HINT_BONUS: Array[int] = [15, 8, 3, 0]

# ---------------------------------------------------------------------------
# Estado em tempo de execução
# ---------------------------------------------------------------------------
var _xp: int = 0
var _level: int = 1
var _mastery: Dictionary = {"matematica": 0, "logica": 0, "linguagem": 0, "ciencias": 0}

# ---------------------------------------------------------------------------
# Ciclo de vida
# ---------------------------------------------------------------------------
func _ready() -> void:
	_sync_from_save()


func _sync_from_save() -> void:
	var prog: Dictionary = SaveSystem.current_save_data.get("progression", {})
	_xp    = prog.get("erudition_xp", prog.get("xp", 0))
	_level = prog.get("erudition_level", prog.get("level", 1))
	_mastery = prog.get("mastery", {"matematica": 0, "logica": 0, "linguagem": 0, "ciencias": 0}).duplicate()

# ---------------------------------------------------------------------------
# API Pública
# ---------------------------------------------------------------------------

## Retorna o XP total acumulado
func get_xp() -> int:
	return _xp


## Retorna o nível atual
func get_level() -> int:
	return _level


## Retorna o título do nível atual
func get_title() -> String:
	return TITLES[clamp(_level - 1, 0, TITLES.size() - 1)]


## Retorna o XP necessário para o próximo nível (0 se já no máximo)
func get_xp_to_next_level() -> int:
	if _level >= MAX_LEVEL:
		return 0
	return THRESHOLDS[_level] - _xp


## Retorna o progresso percentual para o próximo nível (0.0 a 1.0)
func get_level_progress() -> float:
	if _level >= MAX_LEVEL:
		return 1.0
	var current_threshold := THRESHOLDS[_level - 1]
	var next_threshold    := THRESHOLDS[_level]
	var span := next_threshold - current_threshold
	if span <= 0:
		return 1.0
	return float(_xp - current_threshold) / float(span)


## Retorna o valor de mastery numa área (0–100)
func get_mastery(area: String) -> int:
	return _mastery.get(area.to_lower(), 0)


## Calcula e concede XP por resolver um puzzle com sucesso.
## @param difficulty  Dificuldade do puzzle (1 a 5)
## @param area        Área educativa ("matematica", "logica", "linguagem", "ciencias")
## @param hints_used  Número de dicas utilizadas (0 a 3)
func award_puzzle_xp(difficulty: int, area: String, hints_used: int) -> void:
	var base_xp: int = XP_PER_DIFFICULTY[clamp(difficulty - 1, 0, 4)]
	var bonus_xp: int = HINT_BONUS[clamp(hints_used, 0, 3)]
	var total_xp: int = base_xp + bonus_xp

	add_xp(total_xp)
	_increase_mastery(area.to_lower(), difficulty * 2)


## Adiciona XP diretamente (p/ eventos narrativos, bônus de exploração etc.)
func add_xp(amount: int) -> void:
	if amount <= 0:
		return

	_xp += amount
	xp_gained.emit(amount, _xp)

	# Verifica e concede level-ups (pode pular múltiplos níveis de uma vez)
	while _level < MAX_LEVEL and _xp >= THRESHOLDS[_level]:
		_level += 1
		var new_title := get_title()
		level_up.emit(_level, new_title)

	_persist()


## Retorna o XP que seria concedido por um puzzle (para exibição antecipada)
func preview_xp(difficulty: int, hints_used: int) -> int:
	var base_xp: int = XP_PER_DIFFICULTY[clamp(difficulty - 1, 0, 4)]
	var bonus_xp: int = HINT_BONUS[clamp(hints_used, 0, 3)]
	return base_xp + bonus_xp


## Retorna um dicionário resumo para exibição na UI
func get_summary() -> Dictionary:
	return {
		"xp":               _xp,
		"level":            _level,
		"title":            get_title(),
		"xp_to_next":       get_xp_to_next_level(),
		"level_progress":   get_level_progress(),
		"mastery":          _mastery.duplicate(),
	}

# ---------------------------------------------------------------------------
# Internos
# ---------------------------------------------------------------------------

func _increase_mastery(area: String, amount: int) -> void:
	if not _mastery.has(area):
		return
	_mastery[area] = clamp(_mastery[area] + amount, 0, 100)
	mastery_increased.emit(area, _mastery[area])


func _persist() -> void:
	if not SaveSystem.current_save_data.has("progression"):
		SaveSystem.current_save_data["progression"] = {}
	SaveSystem.current_save_data["progression"]["xp"] = _xp
	SaveSystem.current_save_data["progression"]["erudition_xp"] = _xp
	SaveSystem.current_save_data["progression"]["level"] = _level
	SaveSystem.current_save_data["progression"]["erudition_level"] = _level
	SaveSystem.current_save_data["progression"]["mastery_title"] = get_title()
	SaveSystem.current_save_data["progression"]["mastery"] = _mastery.duplicate()
	SaveSystem.save_game()

