extends Node

signal transition_started(target_scene_path: String)
signal transition_finished(target_scene_path: String)

var current_scene: Node = null
var is_transitioning: bool = false

func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	print("[SceneManager] Inicializado. Cena inicial: %s" % (current_scene.name if current_scene else "Nenhuma"))

func change_scene(target_scene_path: String) -> void:
	if is_transitioning:
		return
	is_transitioning = true
	emit_signal("transition_started", target_scene_path)
	print("[SceneManager] Carregando cena: %s" % target_scene_path)
	
	call_deferred("_deferred_change_scene", target_scene_path)

func _deferred_change_scene(target_scene_path: String) -> void:
	if current_scene:
		current_scene.free()
	
	var next_scene_res = ResourceLoader.load(target_scene_path)
	if next_scene_res and next_scene_res is PackedScene:
		current_scene = next_scene_res.instantiate()
		get_tree().root.add_child(current_scene)
		get_tree().current_scene = current_scene
	else:
		push_error("[SceneManager] Falha ao carregar cena em: %s" % target_scene_path)
	
	is_transitioning = false
	emit_signal("transition_finished", target_scene_path)
