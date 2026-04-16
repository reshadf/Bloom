extends CanvasLayer

@onready var grid_container: GridContainer = $ScrollContainer/GridContainer
@onready var back_button: Button = $TopBar/BackButton

const LEVEL_CARD_SCENE: PackedScene = preload("res://scenes/ui/level_card.tscn")

func _ready() -> void:
	back_button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/screens/main_menu.tscn"))
	populate_levels()

func populate_levels() -> void:
	var total = LevelManager.get_total_levels()
	
	for i in range(1, min(total + 1, 51)):  # Show up to 50 levels
		var level_data = LevelManager.get_level(i)
		var card = LEVEL_CARD_SCENE.instantiate()
		
		card.setup(
			i,
			"Level %d" % i,
			level_data.get("biome", "meadow"),
			level_data.get("grid_size", 3),
			LevelManager.get_stars(i),
			LevelManager.is_unlocked(i)
		)
		card.card_pressed.connect(_on_level_selected)
		grid_container.add_child(card)

func _on_level_selected(level_num: int) -> void:
	GameState.current_level = level_num
	get_tree().change_scene_to_file("res://scenes/game/game_screen.tscn")
