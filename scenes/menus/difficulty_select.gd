extends Control

@onready var btn_diff_1: Button = $MarginContainer/VBox/VBoxLevels/BtnDiff1
@onready var btn_diff_2: Button = $MarginContainer/VBox/VBoxLevels/BtnDiff2
@onready var btn_diff_3: Button = $MarginContainer/VBox/VBoxLevels/BtnDiff3
@onready var btn_diff_4: Button = $MarginContainer/VBox/VBoxLevels/BtnDiff4
@onready var btn_diff_5: Button = $MarginContainer/VBox/VBoxLevels/BtnDiff5

@onready var label_selected_desc: Label = $MarginContainer/VBox/PanelInfo/Margin/VBoxDesc/LabelDesc
@onready var label_selected_title: Label = $MarginContainer/VBox/PanelInfo/Margin/VBoxDesc/LabelTitle
@onready var btn_confirm: Button = $MarginContainer/VBox/HBoxActions/BtnConfirm
@onready var btn_back: Button = $MarginContainer/VBox/HBoxActions/BtnBack

var _selected_difficulty: int = 3

const DIFFICULTY_INFO := {
	1: {
		"title": "Nível 1 — Iniciado dos Véus",
		"desc": "Ideal para quem está começando. Puzzles com orientações passo a passo detalhadas, dicas conceituais gratuitas e foco na exploração sem pressa."
	},
	2: {
		"title": "Nível 2 — Aprendiz de Velathys",
		"desc": "Ritmo equilibrado de introdução com desafios que aplicam conceitos fundamentais de lógica e ciências de forma direta e intuitiva."
	},
	3: {
		"title": "Nível 3 — Erudito Investigador (Recomendado)",
		"desc": "A experiência padrão concebida para jovens pesquisadores. Equilíbrio entre narrativa isekai, deduções analíticas e conexões conceituais."
	},
	4: {
		"title": "Nível 4 — Mestre das Ciências",
		"desc": "Para mentes que buscam maior independência. Deduções em múltiplos estágios e menor assistência imediata nas formulações."
	},
	5: {
		"title": "Nível 5 — Sábio de Mnemona",
		"desc": "O teste definitivo de rigor intelectual. Enigmas exigem raciocínio crítico agudo, verificação de hipóteses e máxima precisão."
	}
}

func _ready() -> void:
	AudioManager.play_music("BGM_TITLE_THEME")
	
	btn_diff_1.pressed.connect(func(): _select_difficulty(1))
	btn_diff_2.pressed.connect(func(): _select_difficulty(2))
	btn_diff_3.pressed.connect(func(): _select_difficulty(3))
	btn_diff_4.pressed.connect(func(): _select_difficulty(4))
	btn_diff_5.pressed.connect(func(): _select_difficulty(5))
	
	btn_confirm.pressed.connect(_on_confirm_pressed)
	btn_back.pressed.connect(_on_back_pressed)
	
	# Carrega dificuldade salva ou default 3
	var saved_diff = SaveSystem.current_save_data.get("settings", {}).get("difficulty", 3)
	_select_difficulty(saved_diff)

func _select_difficulty(level: int) -> void:
	AudioManager.play_ui("SFX_UI_TAP")
	_selected_difficulty = level
	
	var info: Dictionary = DIFFICULTY_INFO.get(level, DIFFICULTY_INFO[3])
	label_selected_title.text = info["title"]
	label_selected_desc.text = info["desc"]
	
	_update_buttons_visual()

func _update_buttons_visual() -> void:
	var buttons = [btn_diff_1, btn_diff_2, btn_diff_3, btn_diff_4, btn_diff_5]
	for i in range(buttons.size()):
		var lvl = i + 1
		var btn = buttons[i]
		if lvl == _selected_difficulty:
			btn.modulate = Color(1.2, 1.15, 0.8)
		else:
			btn.modulate = Color(0.85, 0.85, 0.85)

func _on_confirm_pressed() -> void:
	AudioManager.play_ui("SFX_UI_TAP")
	if not SaveSystem.current_save_data.has("settings"):
		SaveSystem.current_save_data["settings"] = {}
	SaveSystem.current_save_data["settings"]["difficulty"] = _selected_difficulty
	SaveSystem.save_game()
	
	# Segue para a introdução narrativa
	SceneManager.change_scene("res://scenes/narrative/NarrativeIntroView.tscn")

func _on_back_pressed() -> void:
	AudioManager.play_ui("SFX_UI_TAP")
	SceneManager.change_scene("res://scenes/menus/MainMenu.tscn")
