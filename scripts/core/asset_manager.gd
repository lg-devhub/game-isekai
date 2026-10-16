extends Node

# Registro canônico de caminhos de assets
const ASSET_PATHS: Dictionary = {
	# Trilhas Musicais (BGM)
	"BGM_TITLE_THEME": "res://assets/audio/music/bgm_title_theme.ogg",
	"BGM_PUZZLE_CONTEMPLATION": "res://assets/audio/music/bgm_puzzle_contemplation.ogg",
	"BGM_CRATER_MYSTERY": "res://assets/audio/music/bgm_crater_mystery.ogg",
	"BGM_VAL_SERENA_DAY": "res://assets/audio/music/bgm_val_serena_day.ogg",
	"BGM_CATACOMBS_ECHO": "res://assets/audio/music/bgm_catacombs_echo.ogg",
	"BGM_CLIMAX_AXIOMS": "res://assets/audio/music/bgm_climax_axioms.ogg",
	"BGM_MNEMONA_SCHOLARS": "res://assets/audio/music/bgm_mnemona_scholars.ogg",

	# Ambiências (BGS)
	"BGS_CRATER_WIND": "res://assets/audio/ambience/bgs_crater_wind.ogg",

	# Efeitos Sonoros Táteis (SFX)
	"SFX_UI_TAP": "res://assets/audio/sfx/sfx_ui_tap.wav",
	"SFX_PAGE_TURN": "res://assets/audio/sfx/sfx_page_turn.wav",
	"SFX_GEAR_CLICK": "res://assets/audio/sfx/sfx_gear_click.wav",
	"SFX_PUZZLE_SUCCESS": "res://assets/audio/sfx/sfx_puzzle_success.wav",
	"SFX_PUZZLE_ERROR": "res://assets/audio/sfx/sfx_puzzle_error.wav",

	# Cenários e Fundos (Environments)
	"BG_TITLE_SCREEN": "res://assets/images/environments/bg_title_screen.png",
	"BG_BLUE_GLASS_CRATER": "res://assets/images/environments/bg_blue_glass_crater.png",
	"BG_PUZZLE_DESK": "res://assets/images/environments/bg_puzzle_desk.png",
	"BG_VAL_SERENA_MARKET": "res://assets/images/environments/bg_val_serena_market.png",
	"BG_MNEMONA_LIBRARY": "res://assets/images/environments/bg_mnemona_library.png",
	"BG_SOLEMNIA_CATACOMBS": "res://assets/images/environments/bg_solemnia_catacombs.png",
	"BG_AXIOMS_TEMPLE": "res://assets/images/environments/bg_axioms_temple.png",

	# Retratos de Personagens (Characters)
	"CHAR_HERO_PORTRAIT_NEUTRAL": "res://assets/images/characters/char_hero_portrait_neutral.png",
	"CHAR_LYRA_PORTRAIT_NEUTRAL": "res://assets/images/characters/char_lyra_portrait_neutral.png",
	"CHAR_LYRA_PORTRAIT_THINKING": "res://assets/images/characters/char_lyra_portrait_thinking.png",
	"CHAR_MALAKOR_PORTRAIT": "res://assets/images/characters/char_malakor_portrait.png",
	"CHAR_TALOS4_PORTRAIT": "res://assets/images/characters/char_talos4_portrait.png",
	"CHAR_VAELEN_PORTRAIT": "res://assets/images/characters/char_vaelen_portrait.png",

	# Ícones Diegéticos
	"ICON_CODEX_BOOK": "res://assets/images/icons/icon_codex_book.png",
	"ICON_HERB_ANIS": "res://assets/images/icons/icon_herb_anis.png",
	"ICON_LUMI_COIN": "res://assets/images/icons/icon_lumi_coin.png",
	"ICON_SALT_PRISM": "res://assets/images/icons/icon_salt_prism.png",

	# Tipografia
	"FONT_BODY": "res://assets/fonts/font_body_text.otf",
	"FONT_TITLE": "res://assets/fonts/font_title_serif.otf"
}

var _texture_cache: Dictionary = {}
var _font_cache: Dictionary = {}
var _placeholder_texture: ImageTexture = null

func _ready() -> void:
	_placeholder_texture = _generate_placeholder_texture(256, 256, Color(0.2, 0.25, 0.35))


func get_texture(asset_id: String) -> Texture2D:
	var key := asset_id.to_upper()
	if _texture_cache.has(key):
		return _texture_cache[key]
	
	var file_path: String = ASSET_PATHS.get(key, ASSET_PATHS.get(asset_id, ""))
	if file_path != "" and FileAccess.file_exists(file_path):
		var tex = ResourceLoader.load(file_path)
		if tex and tex is Texture2D:
			_texture_cache[key] = tex
			return tex
	
	# Fallback procedural seguro
	return _placeholder_texture

func get_audio_stream(asset_id: String) -> AudioStream:
	var key := asset_id.to_upper()
	var file_path: String = ASSET_PATHS.get(key, ASSET_PATHS.get(asset_id, ""))
	if file_path != "" and FileAccess.file_exists(file_path):
		var stream = ResourceLoader.load(file_path)
		if stream and stream is AudioStream:
			return stream
	
	# Retorna null silencioso se arquivo ainda nao foi fornecido
	return null

func get_font(asset_id: String) -> Font:
	var key := asset_id.to_upper()
	if _font_cache.has(key):
		return _font_cache[key]
	
	var file_path: String = ASSET_PATHS.get(key, ASSET_PATHS.get(asset_id, ""))
	if file_path != "" and FileAccess.file_exists(file_path):
		var font_res = ResourceLoader.load(file_path)
		if font_res and font_res is Font:
			_font_cache[key] = font_res
			return font_res
	
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
