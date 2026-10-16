extends Node

var _music_player: AudioStreamPlayer
var _ambience_player: AudioStreamPlayer
var _sfx_players: Array[AudioStreamPlayer] = []
var _ui_player: AudioStreamPlayer

const MAX_SFX_PLAYERS: int = 6

func _ready() -> void:
	_music_player = AudioStreamPlayer.new()
	_music_player.bus = "Music"
	_music_player.finished.connect(_on_music_finished)
	add_child(_music_player)
	
	_ambience_player = AudioStreamPlayer.new()
	_ambience_player.bus = "Ambience"
	_ambience_player.finished.connect(_on_ambience_finished)
	add_child(_ambience_player)
	
	_ui_player = AudioStreamPlayer.new()
	_ui_player.bus = "UI"
	add_child(_ui_player)
	
	for i in range(MAX_SFX_PLAYERS):
		var p = AudioStreamPlayer.new()
		p.bus = "SFX"
		add_child(p)
		_sfx_players.append(p)

var _current_bgm_key: String = ""
var _current_ambience_key: String = ""

func play_music(asset_id: String, _fade_duration: float = 1.0) -> void:
	var key := asset_id.to_upper()
	if _music_player.playing and _current_bgm_key == key:
		return
	
	var stream = AssetManager.get_audio_stream(asset_id)
	if not stream:
		return
	
	if "loop" in stream:
		stream.loop = true
	
	_current_bgm_key = key
	_music_player.stream = stream
	_music_player.play()
	print("[AudioManager] Reproduzindo BGM em Loop: %s" % asset_id)

func _on_music_finished() -> void:
	if not _current_bgm_key.is_empty() and _music_player.stream:
		_music_player.play()

func stop_music(_fade_duration: float = 0.5) -> void:
	_current_bgm_key = ""
	_music_player.stop()

func play_ambience(asset_id: String) -> void:
	var key := asset_id.to_upper()
	if _ambience_player.playing and _current_ambience_key == key:
		return
	var stream = AssetManager.get_audio_stream(asset_id)
	if not stream:
		return
	if "loop" in stream:
		stream.loop = true
	_current_ambience_key = key
	_ambience_player.stream = stream
	_ambience_player.play()

func _on_ambience_finished() -> void:
	if not _current_ambience_key.is_empty() and _ambience_player.stream:
		_ambience_player.play()

func stop_ambience() -> void:
	_current_ambience_key = ""
	_ambience_player.stop()

func play_sfx(asset_id: String) -> void:
	var stream = AssetManager.get_audio_stream(asset_id)
	if not stream:
		return
	
	for p in _sfx_players:
		if not p.playing:
			p.stream = stream
			p.play()
			return
	
	_sfx_players[0].stream = stream
	_sfx_players[0].play()

func play_ui(asset_id: String) -> void:
	var stream = AssetManager.get_audio_stream(asset_id)
	if stream:
		_ui_player.stream = stream
		_ui_player.play()
