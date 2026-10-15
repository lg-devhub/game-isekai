## InventoryManager — Autoload Singleton
## Gerencia o inventário do protagonista:
##   - Itens (usáveis, forenses, cosméticos, chave)
##   - Documentos forenses com detalhes inspecionáveis
##   - Sincroniza com SaveSystem
extends Node


# ---------------------------------------------------------------------------
# Sinais
# ---------------------------------------------------------------------------
signal item_added(item_id: String, quantity: int)
signal item_removed(item_id: String, quantity: int)
signal item_used(item_id: String)
signal forensic_document_added(doc_id: String)
signal forensic_document_inspected(doc_id: String, detail_key: String, content: String)

# ---------------------------------------------------------------------------
# Enumerações
# ---------------------------------------------------------------------------
enum ItemType {
	USABLE,    # Itens consumíveis (dicas extras, reveladores de pistas)
	FORENSIC,  # Documentos / evidências do mundo (não consumidos ao usar)
	COSMETIC,  # Roupas e adornos comprados na loja
	KEY        # Itens de progressão (chaves de narrativa, nunca descartáveis)
}

# ---------------------------------------------------------------------------
# Constantes
# ---------------------------------------------------------------------------
const ITEM_DATA_DIR     := "res://data/items/"
const FORENSIC_DATA_DIR := "res://data/forensic_docs/"

# ---------------------------------------------------------------------------
# Estado interno
# ---------------------------------------------------------------------------
## Definições de itens carregadas dos JSONs: { item_id: Dictionary }
var _item_definitions: Dictionary = {}

## Definições de documentos forenses: { doc_id: Dictionary }
var _forensic_definitions: Dictionary = {}

## Inventário atual: { item_id: int (quantity) }
var _items: Dictionary = {}

## Documentos forenses desbloqueados: Array[String]
var _forensic_docs: Array[String] = []

# ---------------------------------------------------------------------------
# Ciclo de vida
# ---------------------------------------------------------------------------
func _ready() -> void:
	_load_item_definitions()
	_load_forensic_definitions()
	_sync_from_save()


func _load_item_definitions() -> void:
	var dir := DirAccess.open(ITEM_DATA_DIR)
	if dir == null:
		push_warning("InventoryManager: diretório '%s' não encontrado." % ITEM_DATA_DIR)
		return
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".json"):
			_parse_json_into(ITEM_DATA_DIR + file_name, _item_definitions)
		file_name = dir.get_next()
	dir.list_dir_end()


func _load_forensic_definitions() -> void:
	var dir := DirAccess.open(FORENSIC_DATA_DIR)
	if dir == null:
		push_warning("InventoryManager: diretório '%s' não encontrado." % FORENSIC_DATA_DIR)
		return
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".json"):
			_parse_json_into(FORENSIC_DATA_DIR + file_name, _forensic_definitions)
		file_name = dir.get_next()
	dir.list_dir_end()


func _parse_json_into(path: String, target: Dictionary) -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_warning("InventoryManager: não foi possível abrir '%s'." % path)
		return
	var json := JSON.new()
	var err := json.parse(file.get_as_text())
	file.close()
	if err != OK:
		push_warning("InventoryManager: JSON inválido em '%s'." % path)
		return
	var data: Dictionary = json.get_data()
	var entry_id: String = data.get("id", "")
	if entry_id != "":
		target[entry_id] = data


func _sync_from_save() -> void:
	var inv: Dictionary = SaveSystem.current_save_data.get("inventory", {})
	var raw_items = inv.get("items", {})
	if typeof(raw_items) == TYPE_ARRAY:
		_items = {}
		for item in raw_items:
			if typeof(item) == TYPE_STRING:
				_items[item] = _items.get(item, 0) + 1
	elif typeof(raw_items) == TYPE_DICTIONARY:
		_items = raw_items.duplicate()
	else:
		_items = {}
	
	_forensic_docs.clear()
	var raw_docs = inv.get("forensic_docs", inv.get("forensic_documents", []))
	if typeof(raw_docs) == TYPE_ARRAY:
		for doc in raw_docs:
			if typeof(doc) == TYPE_STRING:
				_forensic_docs.append(doc)



# ---------------------------------------------------------------------------
# API — Itens
# ---------------------------------------------------------------------------

## Adiciona `quantity` unidades de `item_id` ao inventário
func add_item(item_id: String, quantity: int = 1) -> void:
	if quantity <= 0:
		return
	_items[item_id] = _items.get(item_id, 0) + quantity
	_persist()
	item_added.emit(item_id, quantity)


## Remove `quantity` unidades. Retorna falso se não houver quantidade suficiente.
func remove_item(item_id: String, quantity: int = 1) -> bool:
	var current: int = _items.get(item_id, 0)
	if current < quantity:
		return false
	_items[item_id] = current - quantity
	if _items[item_id] <= 0:
		_items.erase(item_id)
	_persist()
	item_removed.emit(item_id, quantity)
	return true


## Verifica se o inventário possui pelo menos `quantity` unidades do item
func has_item(item_id: String, quantity: int = 1) -> bool:
	return _items.get(item_id, 0) >= quantity


## Retorna a quantidade atual de um item (0 se não possuir)
func get_quantity(item_id: String) -> int:
	return _items.get(item_id, 0)


## Usa um item (consome 1 unidade se for USABLE; KEY/FORENSIC não são consumidos)
## Retorna falso se o item não existir no inventário ou não for utilizável
func use_item(item_id: String) -> bool:
	if not has_item(item_id):
		return false

	var definition: Dictionary = _item_definitions.get(item_id, {})
	var item_type_str: String = definition.get("type", "USABLE")

	match item_type_str:
		"USABLE":
			if not remove_item(item_id, 1):
				return false
		"FORENSIC", "KEY", "COSMETIC":
			pass  # Não consomem ao usar

	item_used.emit(item_id)
	return true


## Retorna todos os IDs de itens que o jogador possui
func get_all_item_ids() -> Array[String]:
	var result: Array[String] = []
	for key in _items:
		result.append(key)
	return result


## Retorna a definição completa de um item (ou dicionário vazio)
func get_item_definition(item_id: String) -> Dictionary:
	return _item_definitions.get(item_id, {})


## Retorna o nome localizado de um item
func get_item_name(item_id: String) -> String:
	return _item_definitions.get(item_id, {}).get("name", item_id)


## Retorna a descrição localizada de um item
func get_item_description(item_id: String) -> String:
	return _item_definitions.get(item_id, {}).get("description", "")

# ---------------------------------------------------------------------------
# API — Documentos Forenses
# ---------------------------------------------------------------------------

## Adiciona um documento forense ao portfólio do protagonista
func add_forensic_document(doc_id: String) -> void:
	if doc_id in _forensic_docs:
		return  # Já possuído
	_forensic_docs.append(doc_id)
	_persist()
	forensic_document_added.emit(doc_id)


## Retorna verdadeiro se o documento já foi desbloqueado
func has_forensic_document(doc_id: String) -> bool:
	return doc_id in _forensic_docs


## Inspeciona um detalhe específico de um documento forense.
## Retorna o conteúdo textual do detalhe, ou string vazia se não encontrado.
func inspect_document(doc_id: String, detail_key: String) -> String:
	if not has_forensic_document(doc_id):
		push_warning("InventoryManager: documento '%s' não desbloqueado." % doc_id)
		return ""

	var definition: Dictionary = _forensic_definitions.get(doc_id, {})
	var details: Dictionary = definition.get("inspectable_details", {})
	var content: String = details.get(detail_key, "")

	if content != "":
		forensic_document_inspected.emit(doc_id, detail_key, content)

	return content


## Retorna todos os documentos forenses desbloqueados
func get_all_forensic_docs() -> Array[String]:
	return _forensic_docs.duplicate()


## Retorna a definição completa de um documento forense (ou dicionário vazio)
func get_forensic_definition(doc_id: String) -> Dictionary:
	return _forensic_definitions.get(doc_id, {})


## Retorna lista de chaves inspecionáveis de um documento
func get_document_detail_keys(doc_id: String) -> Array[String]:
	var details: Dictionary = _forensic_definitions.get(doc_id, {}).get("inspectable_details", {})
	var result: Array[String] = []
	for key in details:
		result.append(key)
	return result

# ---------------------------------------------------------------------------
# Internos
# ---------------------------------------------------------------------------

func _persist() -> void:
	if not SaveSystem.current_save_data.has("inventory"):
		SaveSystem.current_save_data["inventory"] = {}
	SaveSystem.current_save_data["inventory"]["items"] = _items.duplicate()
	SaveSystem.current_save_data["inventory"]["forensic_docs"] = _forensic_docs.duplicate()
	SaveSystem.current_save_data["inventory"]["forensic_documents"] = _forensic_docs.duplicate()
	SaveSystem.save_game()

