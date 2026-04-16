extends CanvasLayer

func _ready():
	print("SPLASH: HELLO")
	get_tree().change_scene_to_file("res://scenes/screens/main_menu.tscn")
