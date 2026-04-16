extends CanvasLayer

func _ready() -> void:
	print("Splash: _ready() called!")
	await get_tree().create_timer(1.0).timeout
	print("Splash: timer fired!")
	var r = get_tree().change_scene_to_file("res://scenes/screens/main_menu.tscn")
	print("Splash: change_scene result = ", r)
