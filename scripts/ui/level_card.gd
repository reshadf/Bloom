extends PanelContainer

@export var level_number: int = 1
@export var level_name: String = "Level 1"
@export var biome: String = "meadow"
@export var grid_size: int = 3
@export var stars_earned: int = 0
@export var is_unlocked: bool = true

@onready var level_label: Label = $HBox/Info/LevelLabel
@onready var status_label: Label = $HBox/Info/StatusLabel
@onready var stars_label: Label = $HBox/Stars
@onready var icon_label: Label = $HBox/Icon

signal card_pressed(level_num: int)

func _ready() -> void:
	$HBox.gui_input.connect(_on_input)
	update_display()

func _on_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if is_unlocked:
			card_pressed.emit(level_number)

func setup(num: int, name: String, biome_name: String, grid: int, stars: int, unlocked: bool) -> void:
	level_number = num
	level_name = name
	biome = biome_name
	grid_size = grid
	stars_earned = stars
	is_unlocked = unlocked
	update_display()

func update_display() -> void:
	level_label.text = level_name
	status_label.text = " %s • %dx%d" % [biome.capitalize(), grid_size, grid_size]
	stars_label.text = "⭐".repeat(stars_earned) if stars_earned > 0 else ("🔒" if not is_unlocked else "")
	
	# Biome icon
	match biome:
		"meadow": icon_label.text = "🌼"
		"desert": icon_label.text = "🌵"
		"ocean": icon_label.text = "🌊"
		"space": icon_label.text = "🌌"
		"winter": icon_label.text = "❄️"
	
	# Visual state
	if not is_unlocked:
		modulate = Color(0.5, 0.5, 0.5, 0.6)
	else:
		modulate = Color(1, 1, 1, 1)
