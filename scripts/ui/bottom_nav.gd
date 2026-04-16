extends Control
class_name BottomNav
## Bottom navigation bar - Home, Levels, Settings icons

signal home_pressed
signal levels_pressed
signal settings_pressed

@onready var home_button: Button = $HomeButton
@onready var levels_button: Button = $LevelButton
@onready var settings_button: Button = $SettingsButton

var current_tab: String = "home"

func _ready() -> void:
	home_button.pressed.connect(func(): _select_tab("home"))
	levels_button.pressed.connect(func(): _select_tab("levels"))
	settings_button.pressed.connect(func(): _select_tab("settings"))

func _select_tab(tab: String) -> void:
	if tab == current_tab:
		return
	current_tab = tab
	_update_icons()
	
	match tab:
		"home": home_pressed.emit()
		"levels": levels_pressed.emit()
		"settings": settings_pressed.emit()

func _update_icons() -> void:
	home_button.modulate = Color(1, 1, 1, 0.5) if current_tab != "home" else Color.WHITE
	levels_button.modulate = Color(1, 1, 1, 0.5) if current_tab != "levels" else Color.WHITE
	settings_button.modulate = Color(1, 1, 1, 0.5) if current_tab != "settings" else Color.WHITE
