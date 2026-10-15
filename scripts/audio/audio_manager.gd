extends Node

var _music_player: AudioStreamPlayer
var _ambience_player: AudioStreamPlayer
var _sfx_players: Array[AudioStreamPlayer] = []
var _ui_player: AudioStreamPlayer

const MAX_SFX_PLAYERS: int = 6

func _ready() -> void:
	_music_player = AudioStreamPlayer.new()
	_music_player.bus = "Music"
	add_child(_music_player)
	
	_ambience_player = AudioStreamPlayer.new()
	_ambience_player.bus = "Ambience"
	add_child(_ambience_player)
	
	_ui_player = AudioStreamPlayer.new()
	_ui_player.bus = "UI"
	add_child(_ui_player)
	
	for i in range(MAX_SFX_PLAYERS):
		var p = AudioStreamPlayer.new()
		p.bus = "SFX"
		add_child(p)
		_sfx_players.append(p)

func play_music(asset_id: String, fade_duration: float = 1.0) -> void:
	var stream = AssetManager.get_audio_stream(asset_id)
	if not stream:
		return
	
	if _music_player.playing and _music_player.stream == stream:
		return
	
	_music_player.stream = stream
	_music_player.play()
	print("[AudioManager] Reproduzindo BGM: %s" % asset_id)

func stop_music(fade_duration: float = 0.5) -> void:
	_music_player.stop()

func play_ambience(asset_id: String) -> void:
	var stream = AssetManager.get_audio_stream(asset_id)
	if not stream:
		return
	_ambience_player.stream = stream
	_ambience_player.play()

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
