extends CanvasLayer

func _ready() -> void:
	# Simple timer for scene transition
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://scenes/screens/main_menu.tscn")
