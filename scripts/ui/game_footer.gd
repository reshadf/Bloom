extends CanvasLayer

signal grow_pressed()
signal pause_pressed()

# Get button references either as direct children or nested
func _ready() -> void:
	# Try to find buttons in various possible locations
	var grow = find_child("GrowButton", true, false)
	var pause = find_child("PauseButton", true, false)
	
	if grow:
		grow.pressed.connect(_on_grow_pressed)
	if pause:
		pause.pressed.connect(_on_pause_pressed)

func _on_grow_pressed() -> void:
	emit_signal("grow_pressed")

func _on_pause_pressed() -> void:
	emit_signal("pause_pressed")

func set_grow_enabled(enabled: bool) -> void:
	var grow = find_child("GrowButton", true, false)
	if grow:
		grow.disabled = not enabled
		if enabled:
			grow.modulate = Color(1, 0.718, 0.302, 1)  # Gold like primary button
		else:
			grow.modulate = Color(0.4, 0.4, 0.4, 0.5)
