extends Control

@onready var label_title: Label = $CenterContainer/VBoxContainer/LabelTitle
@onready var label_status: Label = $CenterContainer/VBoxContainer/LabelStatus
@onready var progress_bar: ProgressBar = $CenterContainer/VBoxContainer/ProgressBar

func _ready() -> void:
	print("[Boot] Inicializando aplicacao mobile...")
	label_status.text = "Carregando arquivos locais e Códice..."
	
	# Carrega progresso do jogador offline
	SaveSystem.load_game(1)
	
	# Simula transição suave de inicialização
	var timer = get_tree().create_timer(1.2)
	timer.timeout.connect(_on_boot_completed)

func _on_boot_completed() -> void:
	SceneManager.change_scene("res://scenes/menus/MainMenu.tscn")
