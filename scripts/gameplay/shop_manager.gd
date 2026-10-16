## ShopManager — Autoload Singleton
## Gerencia a economia e compras na loja local diegética (100% offline).
## Utiliza apenas Lúmis obtidos por resolução de enigmas e progresso pedagógico.
extends Node

# ---------------------------------------------------------------------------
# Sinais
# ---------------------------------------------------------------------------
signal item_purchased(item_id: String, cost: int)
signal purchase_failed(reason: String)

# ---------------------------------------------------------------------------
# Constantes
# ---------------------------------------------------------------------------
const CATALOG_PATH := "res://data/shop/catalog.json"

# ---------------------------------------------------------------------------
# Estado
# ---------------------------------------------------------------------------
var _catalog: Array[Dictionary] = []
var _shop_name: String = "Loja de Valathys"

func _ready() -> void:
	load_catalog()

func load_catalog() -> void:
	if not FileAccess.file_exists(CATALOG_PATH):
		push_warning("[ShopManager] Catálogo de loja não encontrado em: %s" % CATALOG_PATH)
		return
	
	var file := FileAccess.open(CATALOG_PATH, FileAccess.READ)
	if not file:
		return
	
	var json_str := file.get_as_text()
	file.close()
	
	var parsed: Variant = JSON.parse_string(json_str)
	if parsed is Dictionary:
		_shop_name = parsed.get("shop_name", "Loja de Valathys")
		_catalog.clear()
		for item in parsed.get("items", []):
			if item is Dictionary:
				_catalog.append(item)
	
	print("[ShopManager] Catálogo carregado com %d itens disponíveis." % _catalog.size())

func get_catalog() -> Array[Dictionary]:
	return _catalog

func get_shop_name() -> String:
	return _shop_name

func get_lumis_balance() -> int:
	if SaveSystem.current_save_data.has("economy"):
		return SaveSystem.current_save_data["economy"].get("lumis", 0)
	return 0

func can_buy(item_id: String) -> bool:
	var item_data := get_item_data(item_id)
	if item_data.is_empty():
		return false
	
	var price: int = item_data.get("price_lumis", 9999)
	if get_lumis_balance() < price:
		return false
	
	var max_p: int = item_data.get("max_purchases", -1)
	if max_p == 1 and InventoryManager.has_item(item_id):
		return false
	
	return true

func buy_item(item_id: String) -> bool:
	var item_data := get_item_data(item_id)
	if item_data.is_empty():
		purchase_failed.emit("Item não encontrado no catálogo.")
		return false
	
	var price: int = item_data.get("price_lumis", 0)
	var balance := get_lumis_balance()
	if balance < price:
		AudioManager.play_sfx("SFX_PUZZLE_ERROR")
		purchase_failed.emit("Saldo de Lúmis insuficiente.")
		return false
	
	var max_p: int = item_data.get("max_purchases", -1)
	if max_p == 1 and InventoryManager.has_item(item_id):
		purchase_failed.emit("Você já possui este item exclusivo.")
		return false
	
	# Deduz Lúmis do save
	SaveSystem.current_save_data["economy"]["lumis"] -= price
	var spent = SaveSystem.current_save_data["economy"].get("total_lumis_spent", 0)
	SaveSystem.current_save_data["economy"]["total_lumis_spent"] = spent + price
	
	# Adiciona ao inventário
	InventoryManager.add_item(item_id, 1)
	
	SaveSystem.save_game()
	AudioManager.play_sfx("SFX_GEAR_CLICK")
	item_purchased.emit(item_id, price)
	print("[ShopManager] Item '%s' adquirido com sucesso por %d Lúmis." % [item_id, price])
	return true

func get_item_data(item_id: String) -> Dictionary:
	for item in _catalog:
		if item.get("id", "") == item_id:
			return item
	return {}
