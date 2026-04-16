extends Label

var target_coverage: float = 100.0
var current_coverage: float = 0.0

func _ready() -> void:
	update_display()

func set_coverage(value: float) -> void:
	current_coverage = value
	update_display()
	
	# Color based on how close to target
	var diff = abs(current_coverage - target_coverage)
	if diff < 0.5:
		add_theme_color_override("font_color", Color(0.3, 0.9, 0.3))  # Green - perfect
	elif diff < 10.0:
		add_theme_color_override("font_color", Color(1, 0.85, 0.2))  # Yellow - close
	else:
		add_theme_color_override("font_color", Color(0.9, 0.4, 0.4))  # Red - far

func update_display() -> void:
	text = "%.0f%% / %.0f%%" % [current_coverage, target_coverage]
