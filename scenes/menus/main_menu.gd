extends Control

@onready var btn_start: Button = $MarginContainer/VBoxContainer/VBoxButtons/BtnStart
@onready var btn_codice: Button = $MarginContainer/VBoxContainer/VBoxButtons/BtnCodice
@onready var btn_customization: Button = $MarginContainer/VBoxContainer/VBoxButtons/BtnCustomization
@onready var btn_settings: Button = $MarginContainer/VBoxContainer/VBoxButtons/BtnSettings
@onready var label_version: Label = $MarginContainer/VBoxContainer/LabelVersion

func _ready() -> void:
	GameManager.change_state(GameManager.GameState.MAIN_MENU)
	AudioManager.play_music("BGM_TITLE_THEME")
	
	btn_start.pressed.connect(_on_btn_start_pressed)
	btn_codice.pressed.connect(_on_btn_codice_pressed)
	btn_customization.pressed.connect(_on_btn_customization_pressed)
	btn_settings.pressed.connect(_on_btn_settings_pressed)
	
	var lumis = SaveSystem.current_save_data.get("economy", {}).get("lumis", 50)
	var title = ProgressionManager.get_title()
	var level = ProgressionManager.get_level()
	label_version.text = "Echoes of the Veil v0.2.0-dev | Nível %d: %s | %d Lúmis" % [level, title, lumis]

func _on_btn_start_pressed() -> void:
	AudioManager.play_ui("SFX_UI_TAP")
	SceneManager.change_scene("res://scenes/puzzle/PuzzleView.tscn")

func _on_btn_codice_pressed() -> void:
	AudioManager.play_ui("SFX_UI_TAP")
	SceneManager.change_scene("res://scenes/journal/CodiceView.tscn")

func _on_btn_customization_pressed() -> void:
	AudioManager.play_ui("SFX_UI_TAP")
	SceneManager.change_scene("res://scenes/customization/CustomizationView.tscn")

func _on_btn_settings_pressed() -> void:
	AudioManager.play_ui("SFX_UI_TAP")
	SceneManager.change_scene("res://scenes/settings/SettingsView.tscn")

