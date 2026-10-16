extends Control

# ---------------------------------------------------------------------------
# Referências aos nós
# ---------------------------------------------------------------------------
@onready var btn_back: Button = $MarginContainer/VBox/PanelHeader/Margin/HBox/BtnBack
@onready var label_header_title: Label = $MarginContainer/VBox/PanelHeader/Margin/HBox/LabelHeaderTitle
@onready var label_player_status: Label = $MarginContainer/VBox/PanelHeader/Margin/HBox/LabelPlayerStatus

@onready var tab_main: TabBar = $MarginContainer/VBox/TabBarMain

# Seção de Quests
@onready var panel_quests: VBoxContainer = $MarginContainer/VBox/PanelQuests
@onready var tab_quest_filter: TabBar = $MarginContainer/VBox/PanelQuests/TabBarQuestFilter
@onready var list_quests: ItemList = $MarginContainer/VBox/PanelQuests/HSplit/PanelList/Margin/VBox/ItemListQuests
@onready var label_quest_title: Label = $MarginContainer/VBox/PanelQuests/HSplit/PanelDetails/Margin/Scroll/VBox/LabelQuestTitle
@onready var label_quest_category: Label = $MarginContainer/VBox/PanelQuests/HSplit/PanelDetails/Margin/Scroll/VBox/LabelQuestCategory
@onready var label_quest_lore: Label = $MarginContainer/VBox/PanelQuests/HSplit/PanelDetails/Margin/Scroll/VBox/LabelQuestLore
@onready var label_stage_info: Label = $MarginContainer/VBox/PanelQuests/HSplit/PanelDetails/Margin/Scroll/VBox/LabelStageInfo
@onready var label_objectives: Label = $MarginContainer/VBox/PanelQuests/HSplit/PanelDetails/Margin/Scroll/VBox/LabelObjectives
@onready var label_rewards: Label = $MarginContainer/VBox/PanelQuests/HSplit/PanelDetails/Margin/Scroll/VBox/LabelRewards
@onready var btn_solve_puzzle: Button = $MarginContainer/VBox/PanelQuests/HSplit/PanelDetails/Margin/Scroll/VBox/BtnSolvePuzzle

# Seção de Inventário
@onready var panel_inventory: VBoxContainer = $MarginContainer/VBox/PanelInventory
@onready var tab_inv_filter: TabBar = $MarginContainer/VBox/PanelInventory/TabBarInvFilter
@onready var list_inv: ItemList = $MarginContainer/VBox/PanelInventory/HSplit/PanelList/Margin/VBox/ItemListInv
@onready var label_item_name: Label = $MarginContainer/VBox/PanelInventory/HSplit/PanelDetails/Margin/Scroll/VBox/LabelItemName
@onready var label_item_type: Label = $MarginContainer/VBox/PanelInventory/HSplit/PanelDetails/Margin/Scroll/VBox/LabelItemType
@onready var label_item_desc: Label = $MarginContainer/VBox/PanelInventory/HSplit/PanelDetails/Margin/Scroll/VBox/LabelItemDesc
@onready var label_item_lore: Label = $MarginContainer/VBox/PanelInventory/HSplit/PanelDetails/Margin/Scroll/VBox/LabelItemLore
@onready var btn_use_item: Button = $MarginContainer/VBox/PanelInventory/HSplit/PanelDetails/Margin/Scroll/VBox/BtnUseItem

# Seção de Inspeção Forense (Documentos)
@onready var box_forensic: VBoxContainer = $MarginContainer/VBox/PanelInventory/HSplit/PanelDetails/Margin/Scroll/VBox/VBoxForensic
@onready var container_detail_buttons: HBoxContainer = $MarginContainer/VBox/PanelInventory/HSplit/PanelDetails/Margin/Scroll/VBox/VBoxForensic/HBoxDetailButtons
@onready var label_forensic_result: Label = $MarginContainer/VBox/PanelInventory/HSplit/PanelDetails/Margin/Scroll/VBox/VBoxForensic/PanelResult/Margin/LabelForensicResult

# Estado local
var current_quest_ids: Array[String] = []
var current_selected_quest_id: String = ""
var current_linked_puzzle_id: String = ""

var current_item_ids: Array[String] = []
var current_selected_item_id: String = ""
var current_is_forensic_doc: bool = false

# ---------------------------------------------------------------------------
# Ciclo de vida
# ---------------------------------------------------------------------------
func _ready() -> void:
	AudioManager.play_music("BGM_PUZZLE_CONTEMPLATION")
	_update_player_status()
	
	btn_back.pressed.connect(_on_btn_back_pressed)
	tab_main.tab_changed.connect(_on_main_tab_changed)
	
	# Quests
	tab_quest_filter.tab_changed.connect(_on_quest_filter_changed)
	list_quests.item_selected.connect(_on_quest_selected)
	btn_solve_puzzle.pressed.connect(_on_btn_solve_puzzle_pressed)
	
	# Inventário
	tab_inv_filter.tab_changed.connect(_on_inv_filter_changed)
	list_inv.item_selected.connect(_on_item_selected)
	btn_use_item.pressed.connect(_on_btn_use_item_pressed)
	
	# Configura Abas Principais
	tab_main.clear_tabs()
	tab_main.add_tab("📜 Quests & Investigações")
	tab_main.add_tab("🎒 Inventário & Evidências")
	
	# Configura Filtros de Quests
	tab_quest_filter.clear_tabs()
	tab_quest_filter.add_tab("Em Andamento (Ativas)")
	tab_quest_filter.add_tab("Concluídas")
	
	# Configura Filtros de Inventário
	tab_inv_filter.clear_tabs()
	tab_inv_filter.add_tab("Bolsa de Itens")
	tab_inv_filter.add_tab("Documentos Forenses")
	
	# Inicializa na tela de Quests Ativas
	_set_view_mode(0)

func _update_player_status() -> void:
	var level = ProgressionManager.get_level()
	var title = ProgressionManager.get_title()
	var lumis = SaveSystem.current_save_data.get("economy", {}).get("lumis", 50)
	label_player_status.text = "Nível %d: %s | 💎 %d Lúmis" % [level, title, lumis]

func _on_main_tab_changed(idx: int) -> void:
	AudioManager.play_ui("SFX_PAGE_TURN")
	_set_view_mode(idx)

func _set_view_mode(mode_idx: int) -> void:
	if mode_idx == 0:
		panel_quests.visible = true
		panel_inventory.visible = false
		_load_quests(tab_quest_filter.current_tab)
	else:
		panel_quests.visible = false
		panel_inventory.visible = true
		_load_inventory(tab_inv_filter.current_tab)

# ---------------------------------------------------------------------------
# Lógica de Quests
# ---------------------------------------------------------------------------
func _on_quest_filter_changed(tab_idx: int) -> void:
	AudioManager.play_ui("SFX_UI_TAP")
	_load_quests(tab_idx)

func _load_quests(filter_idx: int) -> void:
	list_quests.clear()
	current_quest_ids.clear()
	
	var target_state = QuestManager.QuestState.ACTIVE if filter_idx == 0 else QuestManager.QuestState.COMPLETED
	current_quest_ids = QuestManager.get_quests_by_state(target_state)
	
	if current_quest_ids.is_empty():
		_display_empty_quest_details(filter_idx == 0)
		return
	
	for q_id in current_quest_ids:
		var title = QuestManager.get_quest_title(q_id)
		var icon_prefix = "🔎 " if filter_idx == 0 else "✔ "
		list_quests.add_item(icon_prefix + title)
	
	list_quests.select(0)
	_display_quest_details(current_quest_ids[0])

func _on_quest_selected(idx: int) -> void:
	if idx >= 0 and idx < current_quest_ids.size():
		AudioManager.play_ui("SFX_UI_TAP")
		_display_quest_details(current_quest_ids[idx])

func _display_quest_details(quest_id: String) -> void:
	current_selected_quest_id = quest_id
	var def = QuestManager.get_quest_definition(quest_id)
	
	label_quest_title.text = def.get("title", quest_id)
	label_quest_category.text = "Categoria: %s • Capítulo: %s" % [
		def.get("category", "Geral").capitalize(),
		def.get("chapter", "Prólogo").capitalize()
	]
	label_quest_lore.text = "Contexto Narrativo:\n%s" % def.get("lore_context", def.get("description", ""))
	
	var cur_stage_idx = QuestManager.get_current_stage(quest_id)
	var stage_data = QuestManager.get_stage_data(quest_id, cur_stage_idx)
	
	if QuestManager.is_completed(quest_id):
		label_stage_info.text = "STATUS DA INVESTIGAÇÃO:\n✔ Caso resolvido e arquivado com sucesso."
		current_linked_puzzle_id = ""
		btn_solve_puzzle.visible = false
	else:
		label_stage_info.text = "ESTÁGIO ATUAL: %s\n%s" % [
			stage_data.get("title", "Em andamento"),
			stage_data.get("description", "")
		]
		current_linked_puzzle_id = stage_data.get("puzzle_id", "")
		btn_solve_puzzle.visible = (current_linked_puzzle_id != "")
		if btn_solve_puzzle.visible:
			btn_solve_puzzle.text = "Resolver Enigma do Estágio (%s)" % current_linked_puzzle_id
	
	# Exibição de Objetivos
	var objs_text = "OBJETIVOS INVESTIGATIVOS:\n"
	var all_objectives = def.get("objectives", [])
	for obj in all_objectives:
		var obj_id = obj.get("id", "")
		var obj_desc = obj.get("description", "")
		var is_done = QuestManager.is_objective_done(quest_id, obj_id)
		var badge = "✔ [CONCLUÍDO] " if is_done else "⏳ [PENDENTE]  "
		objs_text += "%s %s\n" % [badge, obj_desc]
	label_objectives.text = objs_text
	
	# Exibição de Recompensas
	var rew = def.get("rewards", {})
	var rew_text = "RECOMPENSAS PREVISTAS:\n"
	rew_text += "• Lúmis: +%d | XP de Erudição: +%d\n" % [rew.get("lumis", 0), rew.get("xp", 0)]
	if rew.has("items") and not rew["items"].is_empty():
		rew_text += "• Itens: %s\n" % ", ".join(rew["items"])
	if rew.has("codex_entries") and not rew["codex_entries"].is_empty():
		rew_text += "• Códice: %s\n" % ", ".join(rew["codex_entries"])
	label_rewards.text = rew_text

func _display_empty_quest_details(is_active: bool) -> void:
	label_quest_title.text = "Nenhuma quest encontrada"
	label_quest_category.text = ""
	if is_active:
		label_quest_lore.text = "Você não possui investigações em andamento no momento."
	else:
		label_quest_lore.text = "Nenhuma investigação foi arquivada como concluída ainda."
	label_stage_info.text = ""
	label_objectives.text = ""
	label_rewards.text = ""
	btn_solve_puzzle.visible = false

func _on_btn_solve_puzzle_pressed() -> void:
	if current_linked_puzzle_id != "":
		AudioManager.play_ui("SFX_UI_TAP")
		SceneManager.change_scene("res://scenes/puzzle/PuzzleView.tscn")

# ---------------------------------------------------------------------------
# Lógica de Inventário e Forense
# ---------------------------------------------------------------------------
func _on_inv_filter_changed(tab_idx: int) -> void:
	AudioManager.play_ui("SFX_UI_TAP")
	_load_inventory(tab_idx)

func _load_inventory(filter_idx: int) -> void:
	list_inv.clear()
	current_item_ids.clear()
	current_is_forensic_doc = (filter_idx == 1)
	
	if current_is_forensic_doc:
		# Documentos Forenses
		current_item_ids = InventoryManager.get_all_forensic_docs()
		if current_item_ids.is_empty():
			_display_empty_inv_details("Nenhum documento forense recuperado até o momento.")
			return
		
		for doc_id in current_item_ids:
			var doc_def = InventoryManager.get_forensic_definition(doc_id)
			var doc_name = doc_def.get("name", doc_id)
			list_inv.add_item("📜 " + doc_name)
		
		list_inv.select(0)
		_display_forensic_doc_details(current_item_ids[0])
	else:
		# Bolsa de Itens
		current_item_ids = InventoryManager.get_all_item_ids()
		if current_item_ids.is_empty():
			_display_empty_inv_details("Sua bolsa de viagem está vazia.")
			return
		
		for item_id in current_item_ids:
			var item_name = InventoryManager.get_item_name(item_id)
			var qty = InventoryManager.get_quantity(item_id)
			list_inv.add_item("📦 %s (x%d)" % [item_name, qty])
		
		list_inv.select(0)
		_display_item_details(current_item_ids[0])

func _on_item_selected(idx: int) -> void:
	if idx >= 0 and idx < current_item_ids.size():
		AudioManager.play_ui("SFX_UI_TAP")
		if current_is_forensic_doc:
			_display_forensic_doc_details(current_item_ids[idx])
		else:
			_display_item_details(current_item_ids[idx])

func _display_item_details(item_id: String) -> void:
	current_selected_item_id = item_id
	box_forensic.visible = false
	
	var def = InventoryManager.get_item_definition(item_id)
	var qty = InventoryManager.get_quantity(item_id)
	var item_type = def.get("type", "USABLE")
	
	label_item_name.text = def.get("name", item_id)
	label_item_type.text = "Tipo: %s • Quantidade: %d" % [item_type, qty]
	label_item_desc.text = "Descrição:\n%s" % def.get("description", "")
	label_item_lore.text = "\nTradição do Mundo (Lore):\n%s" % def.get("lore", "Sem registros de lore.")
	
	btn_use_item.visible = (item_type == "USABLE")
	btn_use_item.text = "Usar Item"

func _display_forensic_doc_details(doc_id: String) -> void:
	current_selected_item_id = doc_id
	btn_use_item.visible = false
	box_forensic.visible = true
	
	var def = InventoryManager.get_forensic_definition(doc_id)
	label_item_name.text = def.get("name", doc_id)
	label_item_type.text = "Tipo: DOCUMENTO FORENSE PERICIAL"
	label_item_desc.text = "Descrição da Evidência:\n%s" % def.get("description", "")
	label_item_lore.text = "\nContexto Histórico:\n%s" % def.get("lore", "")
	
	# Monta botões de detalhes inspecionáveis
	for child in container_detail_buttons.get_children():
		child.queue_free()
	
	label_forensic_result.text = "Selecione uma área do documento acima para realizar perícia detalhada."
	
	var keys = InventoryManager.get_document_detail_keys(doc_id)
	for k in keys:
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(0, 56)
		btn.theme_override_font_sizes["font_size"] = 20
		btn.text = k.replace("_", " ").capitalize()
		btn.pressed.connect(func(): _on_inspect_detail_pressed(doc_id, k))
		container_detail_buttons.add_child(btn)

func _on_inspect_detail_pressed(doc_id: String, detail_key: String) -> void:
	AudioManager.play_sfx("SFX_PAGE_TURN")
	var content = InventoryManager.inspect_document(doc_id, detail_key)
	label_forensic_result.text = "🔍 DETALHE PERICIAL [%s]:\n%s" % [
		detail_key.replace("_", " ").to_upper(),
		content
	]

func _on_btn_use_item_pressed() -> void:
	if current_selected_item_id != "":
		var success = InventoryManager.use_item(current_selected_item_id)
		if success:
			AudioManager.play_ui("SFX_UI_TAP")
			_load_inventory(0)
			_update_player_status()

func _display_empty_inv_details(msg: String) -> void:
	label_item_name.text = "Nenhum item selecionado"
	label_item_type.text = ""
	label_item_desc.text = msg
	label_item_lore.text = ""
	btn_use_item.visible = false
	box_forensic.visible = false

# ---------------------------------------------------------------------------
# Navegação
# ---------------------------------------------------------------------------
func _on_btn_back_pressed() -> void:
	AudioManager.play_ui("SFX_UI_TAP")
	if GameManager.previous_state == GameManager.GameState.PUZZLE:
		SceneManager.change_scene("res://scenes/puzzle/PuzzleView.tscn")
	else:
		SceneManager.change_scene("res://scenes/menus/MainMenu.tscn")
