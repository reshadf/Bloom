extends CanvasLayer

func _ready() -> void:
	print("Splash: starting...")
	await get_tree().create_timer(2.0).timeout
	print("Splash: timer done, loading main_menu...")
	var result = get_tree().change_scene_to_file("res://scenes/screens/main_menu.tscn")
	if result != OK:
		print("Splash: FAILED to load main_menu, error code: ", result)
	else:
		print("Splash: main_menu loaded successfully")
