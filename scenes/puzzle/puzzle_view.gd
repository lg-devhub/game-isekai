extends Control

@onready var label_area: Label = $MarginContainer/VBoxContainer/PanelHeader/Margin/HBox/LabelArea
@onready var label_lumis: Label = $MarginContainer/VBoxContainer/PanelHeader/Margin/HBox/LabelLumis
@onready var btn_back: Button = $MarginContainer/VBoxContainer/PanelHeader/Margin/HBox/BtnBack
@onready var btn_codice: Button = $MarginContainer/VBoxContainer/PanelHeader/Margin/HBox/BtnCodice

@onready var label_title: Label = $MarginContainer/VBoxContainer/PanelContent/Margin/VBox/LabelTitle
@onready var label_context: Label = $MarginContainer/VBoxContainer/PanelContent/Margin/VBox/LabelContext
@onready var label_prompt: Label = $MarginContainer/VBoxContainer/PanelContent/Margin/VBox/ScrollPrompt/LabelPrompt

@onready var input_line_edit: LineEdit = $MarginContainer/VBoxContainer/VBoxInput/HBoxTextInput/LineEditAnswer
@onready var btn_submit_text: Button = $MarginContainer/VBoxContainer/VBoxInput/HBoxTextInput/BtnSubmit
@onready var vbox_mc_options: VBoxContainer = $MarginContainer/VBoxContainer/VBoxInput/VBoxMultiChoice

@onready var btn_hint1: Button = $MarginContainer/VBoxContainer/HBoxHints/BtnHint1
@onready var btn_hint2: Button = $MarginContainer/VBoxContainer/HBoxHints/BtnHint2
@onready var btn_hint3: Button = $MarginContainer/VBoxContainer/HBoxHints/BtnHint3

@onready var panel_feedback: PanelContainer = $MarginContainer/VBoxContainer/PanelFeedback
@onready var label_feedback_text: Label = $MarginContainer/VBoxContainer/PanelFeedback/Margin/VBox/LabelFeedbackText

@onready var panel_success: PanelContainer = $OverlaySuccess
@onready var label_reward_text: Label = $OverlaySuccess/Margin/VBox/LabelRewards
@onready var btn_success_codice: Button = $OverlaySuccess/Margin/VBox/HBoxSuccessBtns/BtnViewCodice
@onready var btn_next_puzzle: Button = $OverlaySuccess/Margin/VBox/HBoxSuccessBtns/BtnNextPuzzle

@onready var option_puzzle_select: OptionButton = $MarginContainer/VBoxContainer/HBoxSelector/OptionButtonPuzzles

var test_puzzle_ids: Array[String] = [
	"PUZ_MATH_001",
	"PUZ_SCI_001",
	"PUZ_LOG_001",
	"PUZ_LANG_001"
]
var current_test_idx: int = 0

func _ready() -> void:
	GameManager.change_state(GameManager.GameState.PUZZLE)
	AudioManager.play_music("BGM_PUZZLE_CONTEMPLATION")
	
	btn_back.pressed.connect(_on_btn_back_pressed)
	btn_codice.pressed.connect(_on_btn_codice_pressed)
	btn_submit_text.pressed.connect(_on_submit_text_pressed)
	input_line_edit.text_submitted.connect(func(_t): _on_submit_text_pressed())
	
	btn_hint1.pressed.connect(func(): _on_hint_pressed(1))
	btn_hint2.pressed.connect(func(): _on_hint_pressed(2))
	btn_hint3.pressed.connect(func(): _on_hint_pressed(3))
	
	btn_success_codice.pressed.connect(_on_btn_codice_pressed)
	btn_next_puzzle.pressed.connect(_on_next_puzzle_pressed)
	
	PuzzleEngine.puzzle_loaded.connect(_on_puzzle_loaded)
	PuzzleEngine.puzzle_solved.connect(_on_puzzle_solved)
	PuzzleEngine.puzzle_attempt_failed.connect(_on_puzzle_attempt_failed)
	PuzzleEngine.hint_revealed.connect(_on_hint_revealed)
	
	panel_feedback.visible = false
	panel_success.visible = false
	
	_setup_puzzle_selector()
	load_current_puzzle()

func _setup_puzzle_selector() -> void:
	option_puzzle_select.clear()
	option_puzzle_select.add_item("1. Matemática: Tisana Botânica", 0)
	option_puzzle_select.add_item("2. Ciências: Alavanca do Abrigo", 1)
	option_puzzle_select.add_item("3. Lógica: Registro do Agrimensor", 2)
	option_puzzle_select.add_item("4. Linguagem: Manifesto de Carga", 3)
	option_puzzle_select.item_selected.connect(_on_selector_item_selected)

func _on_selector_item_selected(idx: int) -> void:
	current_test_idx = idx
	load_current_puzzle()

func load_current_puzzle() -> void:
	panel_feedback.visible = false
	panel_success.visible = false
	input_line_edit.text = ""
	
	var pid = test_puzzle_ids[current_test_idx]
	PuzzleEngine.load_puzzle(pid)
	_update_lumis_display()

func _on_puzzle_loaded(pdata: Dictionary) -> void:
	var area = pdata.get("educational_area", "DESCONHECIDO")
	label_area.text = "ÁREA: %s" % area
	label_title.text = pdata.get("title", "")
	label_context.text = "Contexto: %s" % pdata.get("narrative_context", "")
	label_prompt.text = pdata.get("prompt", "")
	
	var input_type = pdata.get("input_type", "TEXT_INPUT")
	if input_type == "MULTI_CHOICE":
		$MarginContainer/VBoxContainer/VBoxInput/HBoxTextInput.visible = false
		vbox_mc_options.visible = true
		_build_mc_options(pdata)
	else:
		$MarginContainer/VBoxContainer/VBoxInput/HBoxTextInput.visible = true
		vbox_mc_options.visible = false
	
	btn_hint1.text = "Dica 1 (Grátis)"
	btn_hint2.text = "Dica 2 (10 Lúmis)"
	btn_hint3.text = "Dica 3 (20 Lúmis)"

func _build_mc_options(pdata: Dictionary) -> void:
	for child in vbox_mc_options.get_children():
		child.queue_free()
	
	var options = ["Luneta", "Bússola", "Termômetro"]
	for opt in options:
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(0, 72)
		btn.theme_override_font_sizes["font_size"] = 26
		btn.text = opt
		btn.pressed.connect(func(): _on_mc_option_selected(opt))
		vbox_mc_options.add_child(btn)

func _on_mc_option_selected(option_text: String) -> void:
	AudioManager.play_ui("SFX_UI_TAP")
	PuzzleEngine.submit_answer(option_text)

func _on_submit_text_pressed() -> void:
	var user_text = input_line_edit.text.strip_edges()
	if user_text.is_empty():
		return
	AudioManager.play_ui("SFX_UI_TAP")
	PuzzleEngine.submit_answer(user_text)

func _on_hint_pressed(level: int) -> void:
	var text = PuzzleEngine.request_hint(level)
	if text != "":
		panel_feedback.visible = true
		label_feedback_text.text = "💡 DICA NÍVEL %d:\n%s" % [level, text]

func _on_hint_revealed(level: int, hint_text: String, _cost: int) -> void:
	panel_feedback.visible = true
	label_feedback_text.text = "💡 DICA NÍVEL %d:\n%s" % [level, hint_text]

func _on_puzzle_attempt_failed(diagnostic_text: String) -> void:
	panel_feedback.visible = true
	label_feedback_text.text = "⚠️ OBSERVAÇÃO INVESTIGATIVA:\n%s" % diagnostic_text

func _on_puzzle_solved(_puzzle_id: String, rewards: Dictionary) -> void:
	panel_feedback.visible = false
	panel_success.visible = true
	
	var xp = rewards.get("erudition_xp", 50)
	var lumis = rewards.get("lumis", 25)
	var codex_id = rewards.get("codex_entry_id", "")
	
	var title = ProgressionManager.get_title()
	var level = ProgressionManager.get_level()
	label_reward_text.text = "Dedução Exata!\n+ %d XP de Erudição | + %d Lúmis\nNível %d: %s\nNovo verbete adicionado ao Códice (%s)" % [
		xp, lumis, level, title, codex_id
	]
	_update_lumis_display()


func _update_lumis_display() -> void:
	var l = SaveSystem.current_save_data.get("economy", {}).get("lumis", 50)
	label_lumis.text = "💎 %d Lúmis" % l

func _on_next_puzzle_pressed() -> void:
	current_test_idx = (current_test_idx + 1) % test_puzzle_ids.size()
	option_puzzle_select.selected = current_test_idx
	load_current_puzzle()

func _on_btn_back_pressed() -> void:
	AudioManager.play_ui("SFX_UI_TAP")
	SceneManager.change_scene("res://scenes/menus/MainMenu.tscn")

func _on_btn_codice_pressed() -> void:
	AudioManager.play_ui("SFX_UI_TAP")
	SceneManager.change_scene("res://scenes/journal/CodiceView.tscn")
