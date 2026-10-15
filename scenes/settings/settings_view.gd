## settings_view.gd — Controlador da tela de Configurações
## Sincroniza com SettingsManager (áudio, legibilidade, acessibilidade)
extends Control

# ---------------------------------------------------------------------------
# Referências aos nós
# ---------------------------------------------------------------------------
@onready var slider_master:   HSlider = $MarginContainer/VBox/Section_Audio/SliderMaster
@onready var slider_music:    HSlider = $MarginContainer/VBox/Section_Audio/SliderMusic
@onready var slider_ambience: HSlider = $MarginContainer/VBox/Section_Audio/SliderAmbience
@onready var slider_sfx:      HSlider = $MarginContainer/VBox/Section_Audio/SliderSFX
@onready var slider_ui:       HSlider = $MarginContainer/VBox/Section_Audio/SliderUI

@onready var option_font_size:     OptionButton = $MarginContainer/VBox/Section_Legibility/OptionFontSize
@onready var toggle_colorblind:    CheckButton  = $MarginContainer/VBox/Section_Accessibility/ToggleColorblind
@onready var toggle_reduce_motion: CheckButton  = $MarginContainer/VBox/Section_Accessibility/ToggleReduceMotion

@onready var btn_back:        Button = $MarginContainer/VBox/BtnBack
@onready var btn_reset_saves: Button = $MarginContainer/VBox/Section_Saves/BtnResetSaves
@onready var confirm_panel:   Panel  = $ConfirmPanel
@onready var btn_confirm_yes: Button = $ConfirmPanel/VBox/BtnConfirmYes
@onready var btn_confirm_no:  Button = $ConfirmPanel/VBox/BtnConfirmNo

# ---------------------------------------------------------------------------
# Ciclo de vida
# ---------------------------------------------------------------------------
func _ready() -> void:
	_load_current_settings()
	_connect_signals()
	confirm_panel.visible = false


func _load_current_settings() -> void:
	# Volumes (0.0 a 1.0)
	slider_master.value   = SettingsManager.get_volume("Master")
	slider_music.value    = SettingsManager.get_volume("Music")
	slider_ambience.value = SettingsManager.get_volume("Ambience")
	slider_sfx.value      = SettingsManager.get_volume("SFX")
	slider_ui.value       = SettingsManager.get_volume("UI")

	# Tamanho de fonte: 0=Normal(1.0), 1=Grande(1.2), 2=Máximo(1.5)
	var font_scale: float = SettingsManager.get_font_scale()
	if font_scale >= 1.4:
		option_font_size.selected = 2
	elif font_scale >= 1.15:
		option_font_size.selected = 1
	else:
		option_font_size.selected = 0

	# Acessibilidade
	toggle_colorblind.button_pressed    = SettingsManager.get_colorblind_mode()
	toggle_reduce_motion.button_pressed = SettingsManager.get_reduce_motion()


func _connect_signals() -> void:
	slider_master.value_changed.connect(_on_volume_changed.bind("Master"))
	slider_music.value_changed.connect(_on_volume_changed.bind("Music"))
	slider_ambience.value_changed.connect(_on_volume_changed.bind("Ambience"))
	slider_sfx.value_changed.connect(_on_volume_changed.bind("SFX"))
	slider_ui.value_changed.connect(_on_volume_changed.bind("UI"))

	option_font_size.item_selected.connect(_on_font_size_selected)
	toggle_colorblind.toggled.connect(_on_colorblind_toggled)
	toggle_reduce_motion.toggled.connect(_on_reduce_motion_toggled)

	btn_back.pressed.connect(_on_back_pressed)
	btn_reset_saves.pressed.connect(_on_reset_saves_pressed)
	btn_confirm_yes.pressed.connect(_on_confirm_reset_yes)
	btn_confirm_no.pressed.connect(_on_confirm_reset_no)

# ---------------------------------------------------------------------------
# Callbacks de áudio
# ---------------------------------------------------------------------------
func _on_volume_changed(value: float, bus_name: String) -> void:
	SettingsManager.set_volume(bus_name, value)


# ---------------------------------------------------------------------------
# Callbacks de legibilidade
# ---------------------------------------------------------------------------
func _on_font_size_selected(index: int) -> void:
	const SCALES := [1.0, 1.2, 1.5]
	var scale: float = SCALES[clamp(index, 0, 2)]
	SettingsManager.set_font_scale(scale)
	_apply_font_scale(scale)


func _apply_font_scale(scale: float) -> void:
	# Aplica a escala globalmente via theme override no nó raiz
	# Em produção, isso será substituído por um ThemeManager dedicado
	var root := get_tree().get_root()
	if root:
		root.content_scale_factor = scale

# ---------------------------------------------------------------------------
# Callbacks de acessibilidade
# ---------------------------------------------------------------------------
func _on_colorblind_toggled(pressed: bool) -> void:
	SettingsManager.set_colorblind_mode(pressed)


func _on_reduce_motion_toggled(pressed: bool) -> void:
	SettingsManager.set_reduce_motion(pressed)

# ---------------------------------------------------------------------------
# Navegação
# ---------------------------------------------------------------------------
func _on_back_pressed() -> void:
	SceneManager.change_scene("res://scenes/menus/MainMenu.tscn")

# ---------------------------------------------------------------------------
# Gerenciamento de saves
# ---------------------------------------------------------------------------
func _on_reset_saves_pressed() -> void:
	confirm_panel.visible = true


func _on_confirm_reset_yes() -> void:
	confirm_panel.visible = false
	SaveSystem.reset_save(1)
	# Após reset, retorna ao menu principal
	SceneManager.change_scene("res://scenes/menus/MainMenu.tscn")


func _on_confirm_reset_no() -> void:
	confirm_panel.visible = false
