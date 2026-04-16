extends CanvasLayer

signal home_pressed()
signal restart_pressed()

@onready var level_label: Label = $Bar/HBox/LevelLabel
@onready var moves_label: Label = $Bar/HBox/MovesLabel
@onready var home_btn: Button = $Bar/HBox/HomeButton
@onready var restart_btn: Button = $Bar/HBox/RestartButton

func _ready() -> void:
	home_btn.pressed.connect(func(): emit_signal("home_pressed"))
	restart_btn.pressed.connect(func(): emit_signal("restart_pressed"))

func set_level(num: int) -> void:
	level_label.text = "Level %d" % num

func set_moves(remaining: int) -> void:
	moves_label.text = "Moves: %d" % remaining
	# Turn red when low
	if remaining <= 1:
		moves_label.add_theme_color_override("font_color", Color(0.9, 0.3, 0.3))
	else:
		moves_label.add_theme_color_override("font_color", Color(1, 1, 1))

func set_moves_unlimited() -> void:
	moves_label.text = "∞ Moves"
	moves_label.add_theme_color_override("font_color", Color(1, 1, 1))

func apply_dark_bar(dark: bool) -> void:
	var bar = $Bar
	if dark:
		bar.add_theme_stylebox_override("panel", create_bar_style(Color(0.2, 0.15, 0.12)))
	else:
		bar.add_theme_stylebox_override("panel", create_bar_style(Color(0.365, 0.251, 0.216)))

func create_bar_style(bg_color: Color) -> StyleBoxFlat:
	var s = StyleBoxFlat.new()
	s.bg_color = bg_color
	s.content_margin_left = 16.0
	s.content_margin_right = 16.0
	s.content_margin_top = 12.0
	s.content_margin_bottom = 12.0
	return s
