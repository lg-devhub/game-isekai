extends Control

# Cabeçalho
@onready var label_area: Label = $MarginContainer/VBoxContainer/PanelHeader/Margin/HBox/LabelArea
@onready var label_lumis: Label = $MarginContainer/VBoxContainer/PanelHeader/Margin/HBox/LabelLumis
@onready var btn_back: Button = $MarginContainer/VBoxContainer/PanelHeader/Margin/HBox/BtnBack
@onready var btn_map: Button = $MarginContainer/VBoxContainer/PanelHeader/Margin/HBox/BtnMap
@onready var btn_journal: Button = $MarginContainer/VBoxContainer/PanelHeader/Margin/HBox/BtnJournal
@onready var btn_codice: Button = $MarginContainer/VBoxContainer/PanelHeader/Margin/HBox/BtnCodice

# Cartão do Mentor com Retrato Dinâmico
@onready var texture_companion: TextureRect = $MarginContainer/VBoxContainer/PanelCompanion/Margin/HBox/TextureCompanion
@onready var label_companion_name: Label = $MarginContainer/VBoxContainer/PanelCompanion/Margin/HBox/VBoxText/LabelCompanionName
@onready var label_companion_speech: Label = $MarginContainer/VBoxContainer/PanelCompanion/Margin/HBox/VBoxText/LabelCompanionSpeech

# Conteúdo do Enigma
@onready var label_title: Label = $MarginContainer/VBoxContainer/PanelContent/Margin/VBox/LabelTitle
@onready var label_context: Label = $MarginContainer/VBoxContainer/PanelContent/Margin/VBox/LabelContext
@onready var label_prompt: Label = $MarginContainer/VBoxContainer/PanelContent/Margin/VBox/ScrollPrompt/LabelPrompt

# Painel de Dados Visuais (Tabelas, Pistas, Pergaminhos)
@onready var panel_visual_data: PanelContainer = $MarginContainer/VBoxContainer/PanelContent/Margin/VBox/PanelVisualData
@onready var label_visual_title: Label = $MarginContainer/VBoxContainer/PanelContent/Margin/VBox/PanelVisualData/Margin/VBoxVisual/LabelVisualTitle
@onready var container_visual_content: VBoxContainer = $MarginContainer/VBoxContainer/PanelContent/Margin/VBox/PanelVisualData/Margin/VBoxVisual/ContainerVisualContent

# Dicas com Custos
@onready var btn_hint1: Button = $MarginContainer/VBoxContainer/HBoxHints/BtnHint1
@onready var btn_hint2: Button = $MarginContainer/VBoxContainer/HBoxHints/BtnHint2
@onready var btn_hint3: Button = $MarginContainer/VBoxContainer/HBoxHints/BtnHint3

# Feedback Diagnóstico
@onready var panel_feedback: PanelContainer = $MarginContainer/VBoxContainer/PanelFeedback
@onready var label_feedback_text: Label = $MarginContainer/VBoxContainer/PanelFeedback/Margin/VBox/LabelFeedbackText

# Entradas
@onready var vbox_multi_field: VBoxContainer = $MarginContainer/VBoxContainer/VBoxInput/VBoxMultiField
@onready var hbox_single_input: HBoxContainer = $MarginContainer/VBoxContainer/VBoxInput/HBoxTextInput
@onready var label_single_field: Label = $MarginContainer/VBoxContainer/VBoxInput/HBoxTextInput/LabelSingleField
@onready var input_line_edit: LineEdit = $MarginContainer/VBoxContainer/VBoxInput/HBoxTextInput/LineEditAnswer
@onready var label_unit: Label = $MarginContainer/VBoxContainer/VBoxInput/HBoxTextInput/LabelUnit
@onready var vbox_mc_options: VBoxContainer = $MarginContainer/VBoxContainer/VBoxInput/VBoxMultiChoice
@onready var btn_submit_action: Button = $MarginContainer/VBoxContainer/VBoxInput/BtnSubmitAction

# Painel de Sucesso
@onready var panel_success: PanelContainer = $OverlaySuccess
@onready var label_reward_text: Label = $OverlaySuccess/Margin/VBox/LabelRewards
@onready var label_explanation: Label = $OverlaySuccess/Margin/VBox/ScrollExplanation/LabelExplanation
@onready var btn_success_codice: Button = $OverlaySuccess/Margin/VBox/HBoxSuccessBtns/BtnViewCodice
@onready var btn_success_map: Button = $OverlaySuccess/Margin/VBox/HBoxSuccessBtns/BtnSuccessMap
@onready var btn_next_puzzle: Button = $OverlaySuccess/Margin/VBox/HBoxSuccessBtns/BtnNextPuzzle

# Seletor para testes
@onready var option_puzzle_select: OptionButton = $MarginContainer/VBoxContainer/HBoxSelector/OptionButtonPuzzles

var test_puzzle_ids: Array[String] = [
	"PUZ_MATH_001",
	"PUZ_SCI_001",
	"PUZ_LOG_001",
	"PUZ_LANG_001"
]
var current_test_idx: int = 0
var _current_puzzle_data: Dictionary = {}
var _multi_field_edits: Dictionary = {}
var _selected_mc_choice: String = ""

func _ready() -> void:
	GameManager.change_state(GameManager.GameState.PUZZLE)
	AudioManager.play_music("BGM_PUZZLE_CONTEMPLATION")
	
	btn_back.pressed.connect(_on_btn_back_pressed)
	btn_map.pressed.connect(_on_btn_map_pressed)
	btn_journal.pressed.connect(_on_btn_journal_pressed)
	btn_codice.pressed.connect(_on_btn_codice_pressed)
	
	btn_submit_action.pressed.connect(_on_submit_action_pressed)
	input_line_edit.text_submitted.connect(func(_t): _on_submit_action_pressed())
	
	btn_hint1.pressed.connect(func(): _on_hint_pressed(1))
	btn_hint2.pressed.connect(func(): _on_hint_pressed(2))
	btn_hint3.pressed.connect(func(): _on_hint_pressed(3))
	
	btn_success_codice.pressed.connect(_on_btn_codice_pressed)
	btn_success_map.pressed.connect(_on_btn_map_pressed)
	btn_next_puzzle.pressed.connect(_on_next_puzzle_pressed)
	
	PuzzleEngine.puzzle_loaded.connect(_on_puzzle_loaded)
	PuzzleEngine.puzzle_solved.connect(_on_puzzle_solved)
	PuzzleEngine.puzzle_attempt_failed.connect(_on_puzzle_attempt_failed)
	PuzzleEngine.hint_revealed.connect(_on_hint_revealed)
	
	panel_feedback.visible = false
	panel_success.visible = false
	
	_setup_puzzle_selector()
	
	if not PuzzleEngine.current_puzzle_data.is_empty():
		_on_puzzle_loaded(PuzzleEngine.current_puzzle_data)
	else:
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
	_multi_field_edits.clear()
	_selected_mc_choice = ""
	
	var pid = test_puzzle_ids[current_test_idx]
	PuzzleEngine.load_puzzle(pid)
	_update_lumis_display()

func _on_puzzle_loaded(pdata: Dictionary) -> void:
	_current_puzzle_data = pdata
	var area = pdata.get("educational_area", "DESCONHECIDO")
	label_area.text = "ÁREA: %s" % area
	label_title.text = pdata.get("title", "")
	
	var target_skill = pdata.get("target_skill", "")
	label_context.text = "🎯 Habilidade: %s" % target_skill
	
	# Prompt explícito
	var prompt_text = pdata.get("prompt", "")
	if prompt_text.strip_edges().is_empty():
		prompt_text = pdata.get("narrative_context", "")
	label_prompt.text = prompt_text
	
	# Renderiza painel de dados visuais (tabelas, pistas, textos)
	_setup_visual_data(pdata)
	
	# Configura o mentor e a fala inicial
	_update_companion_for_puzzle(pdata)
	
	# Configura os campos de entrada de acordo com o tipo
	_setup_input_fields(pdata)
	
	# Botão de ação personalizado
	var action_text = pdata.get("action_button_text", "Verificar Dedução")
	btn_submit_action.text = action_text
	
	_update_hint_buttons()
	_update_lumis_display()

func _setup_visual_data(pdata: Dictionary) -> void:
	for child in container_visual_content.get_children():
		child.queue_free()
	
	if not pdata.has("visual_data"):
		panel_visual_data.visible = false
		return
	
	panel_visual_data.visible = true
	var vdata: Dictionary = pdata["visual_data"]
	label_visual_title.text = vdata.get("title", "Informações e Dados do Registro")
	var vtype: String = vdata.get("type", "")
	
	match vtype:
		"table":
			var headers: Array = vdata.get("headers", [])
			var rows: Array = vdata.get("rows", [])
			
			var grid = GridContainer.new()
			grid.columns = headers.size()
			grid.add_theme_constant_override("h_separation", 24)
			grid.add_theme_constant_override("v_separation", 8)
			
			for h in headers:
				var lbl = Label.new()
				lbl.text = str(h)
				lbl.add_theme_color_override("font_color", Color(0.95, 0.85, 0.45))
				lbl.add_theme_font_size_override("font_size", 20)
				grid.add_child(lbl)
			
			for row in rows:
				for cell in row:
					var cell_lbl = Label.new()
					cell_lbl.text = str(cell)
					cell_lbl.add_theme_color_override("font_color", Color(0.9, 0.92, 0.96))
					cell_lbl.add_theme_font_size_override("font_size", 19)
					grid.add_child(cell_lbl)
			
			container_visual_content.add_child(grid)
			
		"clues":
			var items: Array = vdata.get("items", [])
			for item in items:
				var lbl = Label.new()
				lbl.text = "• " + str(item)
				lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
				lbl.add_theme_color_override("font_color", Color(0.85, 0.9, 1.0))
				lbl.add_theme_font_size_override("font_size", 19)
				container_visual_content.add_child(lbl)
				
		"document", "poem":
			var text_content = vdata.get("text", "")
			var lbl = Label.new()
			lbl.text = text_content
			lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			lbl.add_theme_color_override("font_color", Color(0.92, 0.88, 0.78))
			lbl.add_theme_font_size_override("font_size", 20)
			container_visual_content.add_child(lbl)
			
		_:
			panel_visual_data.visible = false

func _setup_input_fields(pdata: Dictionary) -> void:
	_multi_field_edits.clear()
	for child in vbox_multi_field.get_children():
		child.queue_free()
	
	var input_type = pdata.get("input_type", "TEXT_INPUT")
	
	if input_type == "MULTI_FIELD":
		vbox_multi_field.visible = true
		hbox_single_input.visible = false
		vbox_mc_options.visible = false
		btn_submit_action.visible = true
		
		var fields: Array = pdata.get("fields", [])
		for f in fields:
			var hbox = HBoxContainer.new()
			hbox.add_theme_constant_override("separation", 14)
			
			var lbl = Label.new()
			lbl.text = f.get("label", "Quantidade:")
			lbl.custom_minimum_size = Vector2(220, 0)
			lbl.add_theme_font_size_override("font_size", 20)
			lbl.add_theme_color_override("font_color", Color(0.95, 0.88, 0.75))
			hbox.add_child(lbl)
			
			var edit = LineEdit.new()
			edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			edit.custom_minimum_size = Vector2(100, 56)
			edit.placeholder_text = f.get("placeholder", "Ex: valor")
			edit.add_theme_font_size_override("font_size", 22)
			hbox.add_child(edit)
			
			var unit_lbl = Label.new()
			unit_lbl.text = f.get("unit", "")
			unit_lbl.custom_minimum_size = Vector2(80, 0)
			unit_lbl.add_theme_font_size_override("font_size", 18)
			unit_lbl.add_theme_color_override("font_color", Color(0.7, 0.85, 1.0))
			hbox.add_child(unit_lbl)
			
			var fid = f.get("id", str(fields.find(f)))
			_multi_field_edits[fid] = edit
			vbox_multi_field.add_child(hbox)
			
	elif input_type == "MULTIPLE_CHOICE":
		vbox_multi_field.visible = false
		hbox_single_input.visible = false
		vbox_mc_options.visible = true
		btn_submit_action.visible = false
		_build_mc_options(pdata)
		
	else: # NUMERIC_INPUT ou TEXT_INPUT
		vbox_multi_field.visible = false
		hbox_single_input.visible = true
		vbox_mc_options.visible = false
		btn_submit_action.visible = true
		
		label_single_field.text = pdata.get("field_label", "Resposta:")
		input_line_edit.placeholder_text = pdata.get("placeholder", "Digite sua dedução...")
		input_line_edit.text = ""
		label_unit.text = pdata.get("unit", "")

func _build_mc_options(pdata: Dictionary) -> void:
	for child in vbox_mc_options.get_children():
		child.queue_free()
	
	var options = pdata.get("options", ["Opção A", "Opção B", "Opção C"])
	for opt in options:
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(0, 64)
		btn.add_theme_font_size_override("font_size", 22)
		btn.text = "✦  " + opt
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.pressed.connect(func(): _on_mc_option_selected(opt))
		vbox_mc_options.add_child(btn)

func _on_mc_option_selected(option_text: String) -> void:
	AudioManager.play_ui("SFX_UI_TAP")
	PuzzleEngine.submit_answer(option_text)

func _on_submit_action_pressed() -> void:
	var input_type = _current_puzzle_data.get("input_type", "TEXT_INPUT")
	AudioManager.play_ui("SFX_UI_TAP")
	
	if input_type == "MULTI_FIELD":
		var dict_values = {}
		for fid in _multi_field_edits:
			var edit: LineEdit = _multi_field_edits[fid]
			dict_values[fid] = edit.text.strip_edges()
		PuzzleEngine.submit_answer(dict_values)
	else:
		var user_text = input_line_edit.text.strip_edges()
		PuzzleEngine.submit_answer(user_text)

func _update_companion_for_puzzle(pdata: Dictionary) -> void:
	var area = pdata.get("educational_area", "")
	match area:
		"SCIENCES":
			texture_companion.texture = AssetManager.get_texture("CHAR_VAELEN_PORTRAIT")
			label_companion_name.text = "Vaelen (Engenheiro de Val Serena)"
			label_companion_speech.text = "As leis da mecânica e da matéria são exatas. Examine os dados de força, massa e volume antes de acionar o mecanismo."
		"LOGIC":
			texture_companion.texture = AssetManager.get_texture("CHAR_TALOS4_PORTRAIT")
			label_companion_name.text = "Talos-IV (Autômato Arquivista)"
			label_companion_speech.text = "Cruzando premissas documentadas. Elimine as opções que entram em contradição com qualquer uma das pistas."
		_:
			texture_companion.texture = AssetManager.get_texture("CHAR_LYRA_PORTRAIT_NEUTRAL")
			label_companion_name.text = "Lyra (Pesquisadora de Campo)"
			label_companion_speech.text = "Examine a situação com rigor metodológico. A resposta está na análise dos dados fornecidos."

func _update_hint_buttons() -> void:
	var h1_cost = PuzzleEngine.get_hint_cost(1)
	var h2_cost = PuzzleEngine.get_hint_cost(2)
	var h3_cost = PuzzleEngine.get_hint_cost(3)
	
	btn_hint1.text = "💡 Dica 1 (Revelada)" if PuzzleEngine.is_hint_unlocked(1) else "💡 Dica 1 (Grátis)"
	btn_hint2.text = "💡 Dica 2 (Revelada)" if PuzzleEngine.is_hint_unlocked(2) else "💡 Dica 2 (%d Lúmis)" % h2_cost
	btn_hint3.text = "💡 Dica 3 (Revelada)" if PuzzleEngine.is_hint_unlocked(3) else "💡 Dica 3 (%d Lúmis)" % h3_cost

func _on_hint_pressed(level: int) -> void:
	var result = PuzzleEngine.request_hint(level)
	if result["success"]:
		panel_feedback.visible = true
		label_feedback_text.text = "💡 DICA NÍVEL %d:\n%s" % [level, result["text"]]
		texture_companion.texture = AssetManager.get_texture("CHAR_LYRA_PORTRAIT_THINKING")
		label_companion_speech.text = "Pense nesta pista para conectar as partes da sua investigação."
	else:
		panel_feedback.visible = true
		label_feedback_text.text = "⚠️ " + result.get("error", "Não foi possível exibir a dica.")
	
	_update_hint_buttons()
	_update_lumis_display()

func _on_hint_revealed(level: int, hint_text: String, _cost: int) -> void:
	panel_feedback.visible = true
	label_feedback_text.text = "💡 DICA NÍVEL %d:\n%s" % [level, hint_text]
	texture_companion.texture = AssetManager.get_texture("CHAR_LYRA_PORTRAIT_THINKING")
	_update_hint_buttons()
	_update_lumis_display()

func _on_puzzle_attempt_failed(diagnostic_text: String) -> void:
	panel_feedback.visible = true
	label_feedback_text.text = "⚠️ OBSERVAÇÃO INVESTIGATIVA:\n%s" % diagnostic_text
	texture_companion.texture = AssetManager.get_texture("CHAR_LYRA_PORTRAIT_THINKING")
	label_companion_speech.text = "A dedução ainda não se encaixou perfeitamente. Confira a observação diagnóstica abaixo e tente novamente sem pressa."

func _on_puzzle_solved(_puzzle_id: String, rewards: Dictionary) -> void:
	panel_feedback.visible = false
	panel_success.visible = true
	
	texture_companion.texture = AssetManager.get_texture("CHAR_LYRA_PORTRAIT_NEUTRAL")
	label_companion_speech.text = "Excelente dedução! Nossos cálculos estão perfeitamente alinhados e a situação foi resolvida."
	
	var xp = rewards.get("erudition_xp", 50)
	var lumis = rewards.get("lumis", 25)
	var codex_id = rewards.get("codex_entry_id", "")
	
	var title = ProgressionManager.get_title()
	var level = ProgressionManager.get_level()
	label_reward_text.text = "+ %d XP de Erudição | + %d Lúmis | Nível %d: %s\nNovo verbete adicionado ao Códice (%s)" % [
		xp, lumis, level, title, codex_id
	]
	
	var explanation = _current_puzzle_data.get("step_by_step_explanation", "Dedução concluída com sucesso.")
	label_explanation.text = "EXPLICAÇÃO PASSO A PASSO:\n" + explanation
	
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

func _on_btn_map_pressed() -> void:
	AudioManager.play_ui("SFX_UI_TAP")
	SceneManager.change_scene("res://scenes/quest_map/QuestMapView.tscn")

func _on_btn_journal_pressed() -> void:
	AudioManager.play_ui("SFX_UI_TAP")
	SceneManager.change_scene("res://scenes/journal/JournalView.tscn")

func _on_btn_codice_pressed() -> void:
	AudioManager.play_ui("SFX_UI_TAP")
	SceneManager.change_scene("res://scenes/journal/CodiceView.tscn")
