extends Node

enum GameState {
	BOOT,
	MAIN_MENU,
	EXPLORATION,
	DIALOGUE,
	PUZZLE,
	CODICE,
	SETTINGS,
	PAUSED
}

signal state_changed(old_state: GameState, new_state: GameState)
signal puzzle_requested(puzzle_id: String)
signal game_initialized()

var current_state: GameState = GameState.BOOT
var previous_state: GameState = GameState.BOOT
var current_chapter: int = 0
var current_location_id: String = "LOC_BLUE_GLASS_CRATER"

func _ready() -> void:
	print("[GameManager] Inicializando Echoes of the Veil (Modo 100% Offline)...")
	process_mode = Node.PROCESS_MODE_ALWAYS
	emit_signal("game_initialized")

func change_state(new_state: GameState) -> void:
	if current_state == new_state:
		return
	previous_state = current_state
	current_state = new_state
	print("[GameManager] Transicao de estado: %s -> %s" % [GameState.keys()[previous_state], GameState.keys()[current_state]])
	emit_signal("state_changed", previous_state, current_state)

func request_puzzle(puzzle_id: String) -> void:
	print("[GameManager] Solicitando quebra-cabeca educativo: %s" % puzzle_id)
	change_state(GameState.PUZZLE)
	emit_signal("puzzle_requested", puzzle_id)

func return_to_previous_state() -> void:
	change_state(previous_state)
