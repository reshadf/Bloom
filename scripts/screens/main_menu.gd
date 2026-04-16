extends CanvasLayer

@onready var play_button = $VBox/PlayButton
@onready var levels_btn = $VBox/MenuButtons/LevelsBtn
@onready var shop_btn = $VBox/MenuButtons/ShopBtn
@onready var settings_btn = $VBox/MenuButtons/SettingsBtn

func _ready() -> void:
	print("MainMenu: loaded!")
	play_button.pressed.connect(_on_play)
	levels_btn.pressed.connect(_on_levels)
	shop_btn.pressed.connect(_on_shop)
	settings_btn.pressed.connect(_on_settings)

func _on_play() -> void:
	print("MainMenu: play pressed, loading game_screen...")
	var result = get_tree().change_scene_to_file("res://scenes/game/game_screen.tscn")
	if result != OK:
		print("MainMenu: FAILED to load game_screen, error: ", result)

func _on_levels() -> void:
	get_tree().change_scene_to_file("res://scenes/screens/level_select.tscn")

func _on_shop() -> void:
	get_tree().change_scene_to_file("res://scenes/screens/shop_screen.tscn")

func _on_settings() -> void:
	get_tree().change_scene_to_file("res://scenes/screens/settings_screen.tscn")
