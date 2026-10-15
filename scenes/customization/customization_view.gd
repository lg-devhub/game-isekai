## customization_view.gd — Controlador da tela de Customização do Protagonista
## Permite ao jogador escolher tom de pele, cabelo (corte e cor) e roupa.
## As escolhas são salvas em SaveSystem e aplicadas ao sprite do protagonista via AssetManager.
extends Control

# ---------------------------------------------------------------------------
# Enums internos
# ---------------------------------------------------------------------------
enum CustomizationCategory { SKIN, HAIR_STYLE, HAIR_COLOR, OUTFIT }

# ---------------------------------------------------------------------------
# Opções disponíveis (IDs de asset — o AssetManager resolve para textura real)
# ---------------------------------------------------------------------------
const SKIN_TONES: Array[String] = [
	"skin_01_claro", "skin_02_medio_claro", "skin_03_medio",
	"skin_04_medio_escuro", "skin_05_escuro", "skin_06_muito_escuro"
]

const HAIR_STYLES: Array[String] = [
	"hair_style_01_curto", "hair_style_02_medio", "hair_style_03_longo",
	"hair_style_04_trancas", "hair_style_05_crespo"
]

const HAIR_COLORS: Array[String] = [
	"hair_color_preto", "hair_color_castanho", "hair_color_ruivo",
	"hair_color_loiro", "hair_color_branco", "hair_color_cinza"
]

const OUTFITS: Array[String] = [
	"outfit_viajante_basico",    # Desbloqueado desde o início
	"outfit_erudito_aprendiz",   # Desbloqueado ao atingir nível 3
	"outfit_investigador",       # Comprado na loja com Lúmis
]

# ---------------------------------------------------------------------------
# Estado da seleção atual
# ---------------------------------------------------------------------------
var _current: Dictionary = {
	"skin":       "skin_03_medio",
	"hair_style": "hair_style_01_curto",
	"hair_color": "hair_color_preto",
	"outfit":     "outfit_viajante_basico",
}

var _category_index: Dictionary = {
	CustomizationCategory.SKIN:       0,
	CustomizationCategory.HAIR_STYLE: 0,
	CustomizationCategory.HAIR_COLOR: 0,
	CustomizationCategory.OUTFIT:     0,
}

# ---------------------------------------------------------------------------
# Referências aos nós
# ---------------------------------------------------------------------------
@onready var preview_rect:     TextureRect = $MarginContainer/HBox/PreviewPanel/PreviewRect
@onready var label_category:   Label       = $MarginContainer/HBox/ControlPanel/LabelCategory
@onready var label_option:     Label       = $MarginContainer/HBox/ControlPanel/HBoxNav/LabelOption
@onready var btn_prev_option:  Button      = $MarginContainer/HBox/ControlPanel/HBoxNav/BtnPrevOption
@onready var btn_next_option:  Button      = $MarginContainer/HBox/ControlPanel/HBoxNav/BtnNextOption
@onready var tab_bar:          HBoxContainer = $MarginContainer/HBox/ControlPanel/TabBar

@onready var btn_confirm:      Button      = $MarginContainer/HBox/ControlPanel/BtnConfirm
@onready var btn_back:         Button      = $MarginContainer/HBox/ControlPanel/BtnBack

var _active_category: CustomizationCategory = CustomizationCategory.SKIN

# ---------------------------------------------------------------------------
# Ciclo de vida
# ---------------------------------------------------------------------------
func _ready() -> void:
	_load_from_save()
	_build_tab_bar()
	_connect_signals()
	_refresh_ui()


func _load_from_save() -> void:
	var saved: Dictionary = SaveSystem.current_save_data.get("customization", {})
	if saved.has("skin"):       _current["skin"]       = saved["skin"]
	if saved.has("hair_style"): _current["hair_style"] = saved["hair_style"]
	if saved.has("hair_color"): _current["hair_color"] = saved["hair_color"]
	if saved.has("outfit"):     _current["outfit"]     = saved["outfit"]

	# Sincroniza índices com os valores carregados
	_category_index[CustomizationCategory.SKIN]       = SKIN_TONES.find(_current["skin"])
	_category_index[CustomizationCategory.HAIR_STYLE] = HAIR_STYLES.find(_current["hair_style"])
	_category_index[CustomizationCategory.HAIR_COLOR] = HAIR_COLORS.find(_current["hair_color"])
	_category_index[CustomizationCategory.OUTFIT]     = OUTFITS.find(_current["outfit"])


func _build_tab_bar() -> void:
	var labels := ["Pele", "Corte", "Cor do Cabelo", "Roupa"]
	for i in range(labels.size()):
		var btn := Button.new()
		btn.text = labels[i]
		btn.pressed.connect(_on_tab_selected.bind(i))
		tab_bar.add_child(btn)


func _connect_signals() -> void:
	btn_prev_option.pressed.connect(_on_prev_option)
	btn_next_option.pressed.connect(_on_next_option)
	btn_confirm.pressed.connect(_on_confirm)
	btn_back.pressed.connect(_on_back)


# ---------------------------------------------------------------------------
# Atualização da UI
# ---------------------------------------------------------------------------
func _refresh_ui() -> void:
	var category_names := ["Tom de Pele", "Corte de Cabelo", "Cor do Cabelo", "Roupa"]
	label_category.text = category_names[_active_category]

	var options := _get_options_for_category(_active_category)
	var idx: int = _category_index[_active_category]
	var current_id: String = options[clamp(idx, 0, options.size() - 1)]

	label_option.text = _format_option_name(current_id)
	_update_preview(current_id)

	# Desabilita roupa bloqueada
	if _active_category == CustomizationCategory.OUTFIT:
		_update_outfit_lock_state(current_id)


func _get_options_for_category(cat: CustomizationCategory) -> Array[String]:
	match cat:
		CustomizationCategory.SKIN:       return SKIN_TONES
		CustomizationCategory.HAIR_STYLE: return HAIR_STYLES
		CustomizationCategory.HAIR_COLOR: return HAIR_COLORS
		CustomizationCategory.OUTFIT:     return OUTFITS
		_: return []


func _format_option_name(id: String) -> String:
	# Transforma "skin_03_medio" → "Médio (3)"
	var parts := id.split("_")
	if parts.size() >= 2:
		var last := parts[parts.size() - 1]
		return last.capitalize()
	return id


func _update_preview(option_id: String) -> void:
	var texture := AssetManager.get_texture("protagonist_preview_" + option_id)
	if texture:
		preview_rect.texture = texture
	else:
		# Placeholder: limpa textura e deixa o rect colorido por cor de fundo
		preview_rect.texture = null


func _update_outfit_lock_state(outfit_id: String) -> void:
	var locked := false
	match outfit_id:
		"outfit_erudito_aprendiz":
			locked = ProgressionManager.get_level() < 3
		"outfit_investigador":
			locked = not InventoryManager.has_item("ITEM_OUTFIT_INVESTIGADOR")

	btn_confirm.disabled = locked
	if locked:
		label_option.text += " (Bloqueado)"

# ---------------------------------------------------------------------------
# Callbacks de navegação
# ---------------------------------------------------------------------------
func _on_tab_selected(tab_index: int) -> void:
	_active_category = tab_index as CustomizationCategory
	_refresh_ui()


func _on_prev_option() -> void:
	var options := _get_options_for_category(_active_category)
	var idx: int = _category_index[_active_category]
	_category_index[_active_category] = (idx - 1 + options.size()) % options.size()
	_refresh_ui()


func _on_next_option() -> void:
	var options := _get_options_for_category(_active_category)
	var idx: int = _category_index[_active_category]
	_category_index[_active_category] = (idx + 1) % options.size()
	_refresh_ui()

# ---------------------------------------------------------------------------
# Confirmação e persistência
# ---------------------------------------------------------------------------
func _on_confirm() -> void:
	_apply_selection()
	_persist()
	SceneManager.change_scene("res://scenes/menus/MainMenu.tscn")


func _apply_selection() -> void:
	_current["skin"]       = SKIN_TONES[_category_index[CustomizationCategory.SKIN]]
	_current["hair_style"] = HAIR_STYLES[_category_index[CustomizationCategory.HAIR_STYLE]]
	_current["hair_color"] = HAIR_COLORS[_category_index[CustomizationCategory.HAIR_COLOR]]
	_current["outfit"]     = OUTFITS[_category_index[CustomizationCategory.OUTFIT]]


func _persist() -> void:
	SaveSystem.current_save_data["customization"] = _current.duplicate()
	SaveSystem.save_game()


func _on_back() -> void:
	SceneManager.change_scene("res://scenes/menus/MainMenu.tscn")
