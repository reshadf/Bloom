extends Control
class_name PowerupBar
## Power-up bar with 4 booster buttons: Full Bloom, Blossom Spread, Cross Bloom, Seed Burst

signal powerup_selected(type: String)
signal hint_pressed
signal home_pressed
signal restart_pressed

enum PowerupType { FULL_BLOOM, BLOSSOM_SPREAD, CROSS_BLOOM, SEED_BURST }

const POWERUP_SCENE: String = "res://scenes/ui/powerup_button.tscn"

@onready var hint_button: Button = $NavRow/HintButton
@onready var home_button: Button = $NavRow/HomeButton
@onready var restart_button: Button = $NavRow/RestartButton
@onready var powerup_row: HBoxContainer = $PowerupRow

var hint_count: int = 3

func _ready() -> void:
	hint_button.pressed.connect(func(): AudioManager.sfx("click"); hint_pressed.emit())
	home_button.pressed.connect(func(): AudioManager.sfx("click"); home_pressed.emit())
	restart_button.pressed.connect(func(): AudioManager.sfx("click"); restart_pressed.emit())
	
	for type in PowerupType.values():
		var btn = _create_powerup_button(type)
		powerup_row.add_child(btn)

func _create_powerup_button(type: PowerupType) -> Button:
	var btn = Button.new()
	var icons = {
		PowerupType.FULL_BLOOM: "leaf",
		PowerupType.BLOSSOM_SPREAD: "pink_flower",
		PowerupType.CROSS_BLOOM: "purple_flower",
		PowerupType.SEED_BURST: "yellow_flowers",
	}
	btn.icon = _load_icon(icons[type])
	btn.pressed.connect(func(): AudioManager.sfx("click"); powerup_selected.emit(PowerupType.keys()[type]))
	return btn

func _load_icon(name: String) -> Texture2D:
	# TODO: load from assets
	return null

func set_hint_count(count: int) -> void:
	hint_count = count
	hint_button.get_node("CountLabel").text = str(count) if count > 0 else ""
