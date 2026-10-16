extends Control

@onready var label_location: Label = $MarginContainer/VBox/PanelTop/Margin/HBox/LabelLocation
@onready var label_lumis: Label = $MarginContainer/VBox/PanelTop/Margin/HBox/LabelLumis
@onready var label_level: Label = $MarginContainer/VBox/PanelTop/Margin/HBox/LabelLevel
@onready var btn_back: Button = $MarginContainer/VBox/PanelTop/Margin/HBox/BtnBack
@onready var btn_journal: Button = $MarginContainer/VBox/PanelTop/Margin/HBox/BtnJournal
@onready var btn_codice: Button = $MarginContainer/VBox/PanelTop/Margin/HBox/BtnCodice

# Nós da lista de regiões
@onready var vbox_nodes: VBoxContainer = $MarginContainer/VBox/HBoxContent/ScrollNodes/VBoxNodes

# Painel de detalhes da missão
@onready var panel_details: PanelContainer = $MarginContainer/VBox/HBoxContent/PanelDetails
@onready var label_quest_title: Label = $MarginContainer/VBox/HBoxContent/PanelDetails/Margin/VBox/LabelQuestTitle
@onready var label_area_badge: Label = $MarginContainer/VBox/HBoxContent/PanelDetails/Margin/VBox/LabelAreaBadge
@onready var label_status_badge: Label = $MarginContainer/VBox/HBoxContent/PanelDetails/Margin/VBox/LabelStatusBadge
@onready var label_synopsis: Label = $MarginContainer/VBox/HBoxContent/PanelDetails/Margin/VBox/ScrollDetails/VBox/LabelSynopsis
@onready var label_lore: Label = $MarginContainer/VBox/HBoxContent/PanelDetails/Margin/VBox/ScrollDetails/VBox/LabelLore
@onready var label_rewards: Label = $MarginContainer/VBox/HBoxContent/PanelDetails/Margin/VBox/ScrollDetails/VBox/LabelRewards
@onready var btn_action: Button = $MarginContainer/VBox/HBoxContent/PanelDetails/Margin/VBox/BtnAction

const MAP_REGIONS := [
	{
		"id": "REG_CRATER",
		"name": "Cratera do Vidro Azul",
		"chapter": "Prólogo",
		"quest_id": "QP_PROLOGO_01",
		"puzzle_id": "PUZ_MATH_001",
		"area": "Matemática & Razões",
		"area_icon": "📐",
		"synopsis": "Ao despertar na cratera cristalina após atravessar o Véu, você encontra Lyra. O ar denso exige o preparo imediato de uma tisana com proporções exatas de ervas raras.",
		"lore": "A Cratera do Vidro Azul é o epicentro onde as ondas do Véu colidiram com o solo de Velathys, fundindo a areia em quartzo azul.",
		"rewards": "+50 XP Erudição | +25 Lúmis | Verbete: Razão e Proporção",
		"min_level": 1
	},
	{
		"id": "REG_VALDRIM",
		"name": "Trilha & Aldeia de Valdrim",
		"chapter": "Capítulo 1",
		"quest_id": "QP_PROLOGO_02",
		"puzzle_id": "PUZ_LOG_001",
		"area": "Lógica & Pensamento Crítico",
		"area_icon": "🧩",
		"synopsis": "A aldeia desconfia de forasteiros. O ancião Mordrek possui um registro cartográfico corrompido que necessita de dedução relacional para desvendar um instrumento esquecido.",
		"lore": "Valdrim vive sob a lei da autossubsistência no Território Neutro, onde a precisão das ferramentas define a sobrevivência.",
		"rewards": "+60 XP Erudição | +30 Lúmis | Documento Forense",
		"min_level": 1
	},
	{
		"id": "REG_MARKET",
		"name": "Mercado de Val Serena",
		"chapter": "Capítulo 2",
		"quest_id": "QP_CAP2_01",
		"puzzle_id": "PUZ_SCI_001",
		"area": "Ciências & Física Aplicada",
		"area_icon": "🔬",
		"synopsis": "Um mecanismo de alavanca essencial para o canal de irrigação emperrou. Aplique o princípio do momento das forças para restabelecer o equilíbrio das comportas.",
		"lore": "Val Serena é a encruzilhada mercantil onde o conhecimento empírico de engenharia mantém a fertilidade dos campos.",
		"rewards": "+75 XP Erudição | +40 Lúmis | Verbete: Equilíbrio de Alavancas",
		"min_level": 2
	},
	{
		"id": "REG_LIBRARY",
		"name": "Biblioteca de Mnemona",
		"chapter": "Capítulo 3",
		"quest_id": "QP_CAP3_01",
		"puzzle_id": "PUZ_LANG_001",
		"area": "Linguagem & Interpretação",
		"area_icon": "📜",
		"synopsis": "Um manifesto de carga em pergaminho arcaico contém contradições intencionais. Analise as entrelinhas e inferências semânticas para separar o fato da falsificação.",
		"lore": "Mnemona guarda séculos de tratados astronômicos e relatos de contato interdimensional preservados pelos Eruditos da Ordem.",
		"rewards": "+80 XP Erudição | +45 Lúmis | Códice Arcano",
		"min_level": 3
	},
	{
		"id": "REG_TEMPLE",
		"name": "Templo dos Axiomas",
		"chapter": "Capítulo 4 / Clímax",
		"quest_id": "QP_CAP4_01",
		"puzzle_id": "PUZ_MATH_005",
		"area": "Síntese Investigativa",
		"area_icon": "✦",
		"synopsis": "O portal final do Véu exige a integração das quatro áreas do conhecimento para calibrar a frequência harmônica e revelar o caminho de volta para casa.",
		"lore": "Erguido pelos Primeiros Mestres, o Templo responde apenas àqueles que demonstraram maestria intelectual e ética investigativa.",
		"rewards": "+120 XP Erudição | +100 Lúmis | Título de Mestre dos Axiomas",
		"min_level": 4
	}
]

var _selected_region_index: int = 0

func _ready() -> void:
	GameManager.change_state(GameManager.GameState.EXPLORATION)
	AudioManager.play_music("BGM_VAL_SERENA_DAY")
	
	btn_back.pressed.connect(_on_btn_back_pressed)
	btn_journal.pressed.connect(_on_btn_journal_pressed)
	btn_codice.pressed.connect(_on_btn_codice_pressed)
	btn_action.pressed.connect(_on_btn_action_pressed)
	
	_update_header()
	_populate_regions()
	_select_region(0)

func _update_header() -> void:
	var lumis: int = SaveSystem.current_save_data.get("economy", {}).get("lumis", 50)
	var level: int = ProgressionManager.get_level()
	var title: String = ProgressionManager.get_title()
	
	label_lumis.text = "💎 %d Lúmis" % lumis
	label_level.text = "Nvl %d: %s" % [level, title]
	label_location.text = "🗺️ Mapa de Expedições — Velathys"

func _populate_regions() -> void:
	for child in vbox_nodes.get_children():
		child.queue_free()
	
	var player_level = ProgressionManager.get_level()
	
	for i in range(MAP_REGIONS.size()):
		var data = MAP_REGIONS[i]
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(0, 90)
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		var status_text = _get_region_status(data, player_level)
		btn.text = "%s %s\n[%s] • %s" % [data["area_icon"], data["name"], data["chapter"], status_text]
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		
		# Cores de acordo com status
		if status_text.begins_with("Concluída"):
			btn.modulate = Color(0.7, 1.1, 0.8)
		elif status_text.begins_with("Disponível") or status_text.begins_with("Em Progresso"):
			btn.modulate = Color(1.1, 1.05, 0.75)
		else:
			btn.modulate = Color(0.65, 0.65, 0.7)
			
		var idx = i
		btn.pressed.connect(func(): _select_region(idx))
		vbox_nodes.add_child(btn)

func _get_region_status(data: Dictionary, player_level: int) -> String:
	var q_id = data["quest_id"]
	var completed_quests = SaveSystem.current_save_data.get("quests", {}).get("completed_quests", [])
	var active_quests = SaveSystem.current_save_data.get("quests", {}).get("active_quests", [])
	
	if q_id in completed_quests:
		return "Concluída ✓"
	elif q_id in active_quests:
		return "Em Progresso ⏳"
	elif player_level >= data["min_level"]:
		return "Disponível ✦"
	else:
		return "Bloqueada (Nível %d requerido) 🔒" % data["min_level"]

func _select_region(idx: int) -> void:
	_selected_region_index = idx
	var data = MAP_REGIONS[idx]
	var player_level = ProgressionManager.get_level()
	var status = _get_region_status(data, player_level)
	
	label_quest_title.text = "%s %s" % [data["area_icon"], data["name"]]
	label_area_badge.text = "ÁREA: %s" % data["area"]
	label_status_badge.text = "STATUS: %s" % status
	label_synopsis.text = data["synopsis"]
	label_lore.text = "REGISTRO HISTÓRICO:\n%s" % data["lore"]
	label_rewards.text = "RECOMPENSAS:\n%s" % data["rewards"]
	
	if status.begins_with("Bloqueada"):
		btn_action.disabled = true
		btn_action.text = "Requisitos Insuficientes 🔒"
	elif status.begins_with("Concluída"):
		btn_action.disabled = false
		btn_action.text = "Revisar Enigma Investigativo ↺"
	else:
		btn_action.disabled = false
		btn_action.text = "Iniciar Investigação ▶"

func _on_btn_action_pressed() -> void:
	AudioManager.play_ui("SFX_UI_TAP")
	var data = MAP_REGIONS[_selected_region_index]
	var puzzle_id = data["puzzle_id"]
	
	# Garante que a quest esteja no estado ativo
	QuestManager.start_quest(data["quest_id"])
	
	# Carrega o enigma correspondente e abre a tela de resolução
	PuzzleEngine.load_puzzle(puzzle_id)
	SceneManager.change_scene("res://scenes/puzzle/PuzzleView.tscn")

func _on_btn_back_pressed() -> void:
	AudioManager.play_ui("SFX_UI_TAP")
	SceneManager.change_scene("res://scenes/menus/MainMenu.tscn")

func _on_btn_journal_pressed() -> void:
	AudioManager.play_ui("SFX_UI_TAP")
	SceneManager.change_scene("res://scenes/journal/JournalView.tscn")

func _on_btn_codice_pressed() -> void:
	AudioManager.play_ui("SFX_UI_TAP")
	SceneManager.change_scene("res://scenes/journal/CodiceView.tscn")
