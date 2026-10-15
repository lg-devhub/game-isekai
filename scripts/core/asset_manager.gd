extends Node

# Registro canônico de caminhos de assets
const ASSET_PATHS: Dictionary = {
	"BGM_TITLE_THEME": "res://assets/audio/music/bgm_title_theme.ogg",
	"BGM_PUZZLE_CONTEMPLATION": "res://assets/audio/music/bgm_puzzle_contemplation.ogg",
	"BGM_CRATER_MYSTERY": "res://assets/audio/music/bgm_crater_mystery.ogg",
	"BGS_CRATER_WIND": "res://assets/audio/ambience/bgs_crater_wind.ogg",
	"SFX_UI_TAP": "res://assets/audio/sfx/sfx_ui_tap.wav",
	"SFX_PAGE_TURN": "res://assets/audio/sfx/sfx_page_turn.wav",
	"SFX_GEAR_CLICK": "res://assets/audio/sfx/sfx_gear_click.wav",
	"SFX_PUZZLE_SUCCESS": "res://assets/audio/sfx/sfx_puzzle_success.wav",
	"SFX_PUZZLE_ERROR": "res://assets/audio/sfx/sfx_puzzle_error.wav",
	"BG_TITLE_SCREEN": "res://assets/images/environments/bg_title_screen.png",
	"BG_BLUE_GLASS_CRATER": "res://assets/images/environments/bg_blue_glass_crater.png",
	"BG_PUZZLE_DESK": "res://assets/images/environments/bg_puzzle_desk.png",
	"CHAR_HERO_PORTRAIT_NEUTRAL": "res://assets/images/characters/char_hero_portrait_neutral.png",
	"CHAR_LYRA_PORTRAIT_NEUTRAL": "res://assets/images/characters/char_lyra_portrait_neutral.png"
}

var _texture_cache: Dictionary = {}
var _placeholder_texture: ImageTexture = null

func _ready() -> void:
	_placeholder_texture = _generate_placeholder_texture(256, 256, Color(0.2, 0.25, 0.35))

func get_texture(asset_id: String) -> Texture2D:
	if _texture_cache.has(asset_id):
		return _texture_cache[asset_id]
	
	if ASSET_PATHS.has(asset_id):
		var file_path = ASSET_PATHS[asset_id]
		if FileAccess.file_exists(file_path):
			var tex = ResourceLoader.load(file_path)
			if tex and tex is Texture2D:
				_texture_cache[asset_id] = tex
				return tex
	
	# Fallback procedural seguro
	return _placeholder_texture

func get_audio_stream(asset_id: String) -> AudioStream:
	if ASSET_PATHS.has(asset_id):
		var file_path = ASSET_PATHS[asset_id]
		if FileAccess.file_exists(file_path):
			var stream = ResourceLoader.load(file_path)
			if stream and stream is AudioStream:
				return stream
	
	# Retorna null silencioso se arquivo ainda nao foi fornecido
	return null

func _generate_placeholder_texture(w: int, h: int, base_color: Color) -> ImageTexture:
	var img = Image.create(w, h, false, Image.FORMAT_RGBA8)
	var checker_dark = base_color.darkened(0.2)
	var checker_light = base_color.lightened(0.2)
	
	for y in range(h):
		for x in range(w):
			var is_even = ((x / 32) + (y / 32)) % 2 == 0
			img.set_pixel(x, y, checker_light if is_even else checker_dark)
	
	return ImageTexture.create_from_image(img)
