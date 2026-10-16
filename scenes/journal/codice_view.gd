extends Control

@onready var btn_back: Button = $MarginContainer/VBox/PanelHeader/Margin/HBox/BtnBack
@onready var tab_bar: TabBar = $MarginContainer/VBox/TabBarAreas

@onready var item_list: ItemList = $MarginContainer/VBox/HSplit/PanelList/Margin/VBox/ItemListEntries
@onready var label_entry_title: Label = $MarginContainer/VBox/HSplit/PanelDetails/Margin/VBox/LabelEntryTitle
@onready var label_target_skill: Label = $MarginContainer/VBox/HSplit/PanelDetails/Margin/VBox/LabelTargetSkill
@onready var label_summary: Label = $MarginContainer/VBox/HSplit/PanelDetails/Margin/VBox/ScrollDetails/VBox/LabelSummary
@onready var label_formal: Label = $MarginContainer/VBox/HSplit/PanelDetails/Margin/VBox/ScrollDetails/VBox/LabelFormal
@onready var label_examples: Label = $MarginContainer/VBox/HSplit/PanelDetails/Margin/VBox/ScrollDetails/VBox/LabelExamples
@onready var label_application: Label = $MarginContainer/VBox/HSplit/PanelDetails/Margin/VBox/ScrollDetails/VBox/LabelApplication

var current_area_entries: Array[Dictionary] = []

func _ready() -> void:
	AudioManager.play_music("BGM_PUZZLE_CONTEMPLATION")
	btn_back.pressed.connect(_on_btn_back_pressed)
	tab_bar.tab_changed.connect(_on_tab_changed)
	item_list.item_selected.connect(_on_item_selected)
	
	tab_bar.clear_tabs()
	tab_bar.add_tab("Matemática")
	tab_bar.add_tab("Lógica")
	tab_bar.add_tab("Linguagem")
	tab_bar.add_tab("Ciências")
	
	_load_tab_entries(0)

func _on_tab_changed(tab_idx: int) -> void:
	AudioManager.play_ui("SFX_PAGE_TURN")
	_load_tab_entries(tab_idx)

func _load_tab_entries(tab_idx: int) -> void:
	var area_name = ""
	match tab_idx:
		0: area_name = "MATHEMATICS"
		1: area_name = "LOGIC"
		2: area_name = "LANGUAGE"
		3: area_name = "SCIENCES"
	
	current_area_entries = CodiceManager.get_entries_by_area(area_name)
	item_list.clear()
	
	if current_area_entries.is_empty():
		_display_empty_details()
		return
	
	for entry in current_area_entries:
		var title = entry.get("title", "Sem Título")
		var entry_id = entry.get("id", "")
		var is_unlocked = CodiceManager.is_entry_unlocked(entry_id)
		if is_unlocked:
			item_list.add_item("📖 " + title)
		else:
			item_list.add_item("🔒 " + title + " (Bloqueado)")
	
	item_list.select(0)
	_display_entry(current_area_entries[0])

func _on_item_selected(index: int) -> void:
	if index >= 0 and index < current_area_entries.size():
		AudioManager.play_ui("SFX_UI_TAP")
		_display_entry(current_area_entries[index])

func _display_entry(entry: Dictionary) -> void:
	var entry_id = entry.get("id", "")
	var is_unlocked = CodiceManager.is_entry_unlocked(entry_id)
	
	label_entry_title.text = entry.get("title", "")
	label_target_skill.text = "Competência: %s" % entry.get("target_skill", "")
	
	if is_unlocked:
		label_summary.text = "RESUMO CONCEITUAL:\n%s" % entry.get("concept_summary", "")
		label_formal.text = "\nDEMONSTRAÇÃO FORMAL:\n%s" % entry.get("formal_explanation", "")
		
		var ex_str = "\nEXEMPLOS RESOLVIDOS:\n"
		var examples = entry.get("solved_examples", [])
		for ex in examples:
			ex_str += "• Problema: %s\n  Passo a Passo: %s\n" % [ex.get("problem", ""), ex.get("solution_steps", "")]
		label_examples.text = ex_str
		
		label_application.text = "\nAPLICAÇÃO NO MUNDO REAL:\n%s" % entry.get("related_real_world_application", "")
	else:
		label_summary.text = "🔒 Este verbete ainda não foi investigado.\nResolva os enigmas associados no mapa para registrar esta síntese no Códice."
		label_formal.text = ""
		label_examples.text = ""
		label_application.text = ""

func _display_empty_details() -> void:
	label_entry_title.text = "Nenhum verbete registrado nesta área"
	label_target_skill.text = ""
	label_summary.text = "Explore o mundo e resolva quebra-cabeças para preencher este capítulo."
	label_formal.text = ""
	label_examples.text = ""
	label_application.text = ""

func _on_btn_back_pressed() -> void:
	AudioManager.play_ui("SFX_UI_TAP")
	if GameManager.previous_state == GameManager.GameState.PUZZLE:
		SceneManager.change_scene("res://scenes/puzzle/PuzzleView.tscn")
	else:
		SceneManager.change_scene("res://scenes/menus/MainMenu.tscn")
