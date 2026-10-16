## shop_view.gd — Controlador da tela do Bazar dos Eruditos (Loja Diegética)
extends Control

@onready var label_shop_title: Label = $MarginContainer/VBox/Header/LabelTitle
@onready var label_lumis: Label = $MarginContainer/VBox/Header/LabelLumis
@onready var vbox_items: VBoxContainer = $MarginContainer/VBox/Scroll/VBoxItems
@onready var btn_back: Button = $MarginContainer/VBox/BtnBack
@onready var label_feedback: Label = $MarginContainer/VBox/LabelFeedback

func _ready() -> void:
	AudioManager.play_music("BGM_VAL_SERENA_DAY")
	label_shop_title.text = ShopManager.get_shop_name()
	label_feedback.text = ""
	btn_back.pressed.connect(_on_btn_back_pressed)
	ShopManager.item_purchased.connect(_on_item_purchased)
	ShopManager.purchase_failed.connect(_on_purchase_failed)
	
	_update_lumis_display()
	_populate_catalog()

func _update_lumis_display() -> void:
	label_lumis.text = "💎 Saldo: %d Lúmis" % ShopManager.get_lumis_balance()

func _populate_catalog() -> void:
	for child in vbox_items.get_children():
		child.queue_free()
	
	var catalog = ShopManager.get_catalog()
	for item in catalog:
		var card = _create_item_card(item)
		vbox_items.add_child(card)

func _create_item_card(item: Dictionary) -> PanelContainer:
	var panel = PanelContainer.new()
	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_bottom", 16)
	panel.add_child(margin)
	
	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 20)
	margin.add_child(hbox)
	
	# Info
	var vbox_info = VBoxContainer.new()
	vbox_info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox_info.add_theme_constant_override("separation", 6)
	hbox.add_child(vbox_info)
	
	var lbl_name = Label.new()
	lbl_name.text = item.get("name", "")
	lbl_name.add_theme_font_size_override("font_size", 26)
	lbl_name.add_theme_color_override("font_color", Color(0.95, 0.85, 0.5, 1.0))
	vbox_info.add_child(lbl_name)
	
	var lbl_desc = Label.new()
	lbl_desc.text = item.get("description", "")
	lbl_desc.add_theme_font_size_override("font_size", 20)
	lbl_desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox_info.add_child(lbl_desc)
	
	var lbl_lore = Label.new()
	lbl_lore.text = "“" + item.get("lore", "") + "”"
	lbl_lore.add_theme_font_size_override("font_size", 18)
	lbl_lore.add_theme_color_override("font_color", Color(0.65, 0.7, 0.8, 1.0))
	lbl_lore.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox_info.add_child(lbl_lore)
	
	# Botão de Compra
	var item_id: String = item.get("id", "")
	var price: int = item.get("price_lumis", 0)
	var max_p: int = item.get("max_purchases", -1)
	var already_owned = (max_p == 1 and InventoryManager.has_item(item_id))
	
	var btn_buy = Button.new()
	btn_buy.custom_minimum_size = Vector2(220, 80)
	btn_buy.add_theme_font_size_override("font_size", 22)
	
	if already_owned:
		btn_buy.text = "Adquirido"
		btn_buy.disabled = true
	else:
		btn_buy.text = "Comprar\n%d Lúmis" % price
		btn_buy.disabled = not ShopManager.can_buy(item_id)
		btn_buy.pressed.connect(func():
			ShopManager.buy_item(item_id)
		)
	
	hbox.add_child(btn_buy)
	return panel

func _on_item_purchased(item_id: String, cost: int) -> void:
	var item_data = ShopManager.get_item_data(item_id)
	label_feedback.text = "✅ %s adquirido por %d Lúmis!" % [item_data.get("name", item_id), cost]
	label_feedback.modulate = Color(0.4, 1.0, 0.4, 1.0)
	_update_lumis_display()
	_populate_catalog()

func _on_purchase_failed(reason: String) -> void:
	label_feedback.text = "❌ %s" % reason
	label_feedback.modulate = Color(1.0, 0.4, 0.4, 1.0)

func _on_btn_back_pressed() -> void:
	AudioManager.play_ui("SFX_UI_TAP")
	SceneManager.change_scene("res://scenes/menus/MainMenu.tscn")
