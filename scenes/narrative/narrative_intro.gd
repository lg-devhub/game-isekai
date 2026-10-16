extends Control

@onready var dialogue_box: Control = $DialogueBox
@onready var btn_skip: Button = $MarginContainer/HBoxTop/BtnSkip
@onready var label_location: Label = $MarginContainer/HBoxTop/LabelLocation

func _ready() -> void:
	GameManager.change_state(GameManager.GameState.DIALOGUE)
	AudioManager.play_music("BGM_CRATER_MYSTERY")
	AudioManager.play_ambience("BGS_CRATER_WIND")
	
	btn_skip.pressed.connect(_on_skip_pressed)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	
	# Inicia o diálogo de prólogo com Lyra e o protagonista
	# Aguardamos um frame para garantir que os nós da UI estejam inicializados
	call_deferred("_start_intro_dialogue")

func _start_intro_dialogue() -> void:
	DialogueManager.start_dialogue("DIA_PROLOGO_01")

func _on_dialogue_ended(dialogue_id: String) -> void:
	if dialogue_id == "DIA_PROLOGO_01":
		# Salva progresso da quest inicial se ainda não salva
		QuestManager.start_quest("QP_PROLOGO_01")
		# Segue para o mapa de expedição ou primeiro enigma
		SceneManager.change_scene("res://scenes/quest_map/QuestMapView.tscn")

func _on_skip_pressed() -> void:
	AudioManager.play_ui("SFX_UI_TAP")
	DialogueManager.end_dialogue()
	QuestManager.start_quest("QP_PROLOGO_01")
	SceneManager.change_scene("res://scenes/quest_map/QuestMapView.tscn")
