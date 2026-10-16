## dialogue_box.gd — Controlador visual do componente de diálogo
extends Control

@onready var panel_root: PanelContainer = $PanelContainer
@onready var texture_portrait: TextureRect = $PanelContainer/Margin/HBox/TexturePortrait
@onready var label_name: Label = $PanelContainer/Margin/HBox/VBoxText/HBoxHeader/LabelName
@onready var label_title: Label = $PanelContainer/Margin/HBox/VBoxText/HBoxHeader/LabelTitle
@onready var label_text: Label = $PanelContainer/Margin/HBox/VBoxText/LabelText
@onready var vbox_choices: VBoxContainer = $PanelContainer/Margin/HBox/VBoxText/VBoxChoices
@onready var btn_advance: Button = $PanelContainer/Margin/HBox/VBoxText/BtnAdvance

func _ready() -> void:
	visible = false
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.node_displayed.connect(_on_node_displayed)
	DialogueManager.choices_presented.connect(_on_choices_presented)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	btn_advance.pressed.connect(_on_advance_pressed)

func _on_dialogue_started(_dialogue_id: String) -> void:
	visible = true

func _on_node_displayed(node_data: Dictionary) -> void:
	visible = true
	label_name.text = node_data.get("speaker", "Desconhecido")
	label_title.text = "- " + node_data.get("speaker_title", "")
	label_text.text = node_data.get("text", "")
	
	var portrait_key: String = node_data.get("portrait_key", "")
	if portrait_key != "":
		texture_portrait.texture = AssetManager.get_texture(portrait_key)
		texture_portrait.visible = true
	else:
		texture_portrait.visible = false
	
	_clear_choices()
	
	var choices: Array = node_data.get("choices", [])
	btn_advance.visible = choices.is_empty()

func _on_choices_presented(choices: Array) -> void:
	_clear_choices()
	btn_advance.visible = false
	
	for i in range(choices.size()):
		var choice = choices[i]
		var btn = Button.new()
		btn.text = choice.get("text", "")
		btn.custom_minimum_size = Vector2(0, 64)
		btn.add_theme_font_size_override("font_size", 22)
		btn.pressed.connect(func():
			AudioManager.play_ui("SFX_UI_TAP")
			DialogueManager.select_choice(i)
		)
		vbox_choices.add_child(btn)

func _clear_choices() -> void:
	for child in vbox_choices.get_children():
		child.queue_free()

func _on_advance_pressed() -> void:
	AudioManager.play_ui("SFX_UI_TAP")
	DialogueManager.advance()

func _on_dialogue_ended(_dialogue_id: String) -> void:
	visible = false
	_clear_choices()
