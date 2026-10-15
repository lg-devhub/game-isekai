extends Node

signal settings_changed()

const SETTINGS_PATH: String = "user://settings.cfg"

var config: ConfigFile = ConfigFile.new()

var master_volume: float = 0.8
var music_volume: float = 0.75
var sfx_volume: float = 0.85
var ambience_volume: float = 0.70
var ui_volume: float = 0.80

var font_size_scale: float = 1.0
var high_contrast: bool = false
var text_speed: int = 40
var auto_advance: bool = false
var language_code: String = "pt-BR"

func _ready() -> void:
	load_settings()

func load_settings() -> void:
	var err = config.load(SETTINGS_PATH)
	if err != OK:
		print("[SettingsManager] Config padrao inicializada.")
		save_settings()
		return
	
	master_volume = config.get_value("audio", "master_volume", 0.8)
	music_volume = config.get_value("audio", "music_volume", 0.75)
	sfx_volume = config.get_value("audio", "sfx_volume", 0.85)
	ambience_volume = config.get_value("audio", "ambience_volume", 0.70)
	ui_volume = config.get_value("audio", "ui_volume", 0.80)
	
	font_size_scale = config.get_value("display", "font_size_scale", 1.0)
	high_contrast = config.get_value("display", "high_contrast", false)
	text_speed = config.get_value("gameplay", "text_speed", 40)
	auto_advance = config.get_value("gameplay", "auto_advance", false)
	language_code = config.get_value("gameplay", "language_code", "pt-BR")
	
	apply_audio_settings()
	emit_signal("settings_changed")

func save_settings() -> void:
	config.set_value("audio", "master_volume", master_volume)
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sfx_volume", sfx_volume)
	config.set_value("audio", "ambience_volume", ambience_volume)
	config.set_value("audio", "ui_volume", ui_volume)
	
	config.set_value("display", "font_size_scale", font_size_scale)
	config.set_value("display", "high_contrast", high_contrast)
	config.set_value("gameplay", "text_speed", text_speed)
	config.set_value("gameplay", "auto_advance", auto_advance)
	config.set_value("gameplay", "language_code", language_code)
	
	config.save(SETTINGS_PATH)
	apply_audio_settings()
	emit_signal("settings_changed")

func apply_audio_settings() -> void:
	set_bus_volume("Master", master_volume)
	set_bus_volume("Music", music_volume)
	set_bus_volume("SFX", sfx_volume)
	set_bus_volume("Ambience", ambience_volume)
	set_bus_volume("UI", ui_volume)

func set_bus_volume(bus_name: String, linear_vol: float) -> void:
	var bus_idx = AudioServer.get_bus_index(bus_name)
	if bus_idx >= 0:
		var db_val = linear_to_db(clamp(linear_vol, 0.0001, 1.0))
		AudioServer.set_bus_volume_db(bus_idx, db_val)
		AudioServer.set_bus_mute(bus_idx, linear_vol <= 0.001)
