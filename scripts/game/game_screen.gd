extends CanvasLayer

@onready var grid: Node2D = $GridContainer/Grid
@onready var header: CanvasLayer = $GameHeader
@onready var footer: CanvasLayer = $GameFooter
@onready var plant_toolbar: HBoxContainer = $PlantToolbar

# Header refs
@onready var level_label: Label = $GameHeader/Bar/HBox/LevelLabel
@onready var moves_label: Label = $GameHeader/Bar/HBox/MovesLabel
@onready var home_btn: Button = $GameHeader/Bar/HBox/HomeButton
@onready var restart_btn: Button = $GameHeader/Bar/HBox/RestartButton

# Footer refs
@onready var grow_btn: Button = $GameFooter/GrowButton
@onready var pause_btn: Button = $GameFooter/PauseButton

# Plant toolbar buttons
@onready var flower_btn: Button = $PlantToolbar/FlowerBtn
@onready var bush_btn: Button = $PlantToolbar/BushBtn
@onready var star_btn: Button = $PlantToolbar/StarBtn
@onready var cactus_btn: Button = $PlantToolbar/CactusBtn

var current_level: int = 1
var confetti: Node = null
var result_modal: Node = null
var selected_plant: String = "flower"
var unlocked_plants: Array = ["flower"]

func _ready() -> void:
	# Header signals
	home_btn.pressed.connect(_on_home)
	restart_btn.pressed.connect(_on_retry)
	
	# Footer signals
	grow_btn.pressed.connect(_on_grow)
	pause_btn.pressed.connect(_on_pause)
	
	# Grid signals
	grid.connect("move_used", _on_move_used)
	grid.connect("all_plants_grown", _on_all_plants_grown)
	
	# Plant toolbar
	flower_btn.pressed.connect(func(): select_plant("flower"))
	bush_btn.pressed.connect(func(): select_plant("bush"))
	star_btn.pressed.connect(func(): select_plant("star"))
	cactus_btn.pressed.connect(func(): select_plant("cactus"))
	
	# Disable grow initially
	grow_btn.disabled = true
	grow_btn.modulate = Color(0.6, 0.6, 0.6, 0.5)
	
	# Create confetti
	confetti = preload("res://scripts/game/confetti_burst.gd").new()
	add_child(confetti)
	
	start_level(GameState.current_level)

func select_plant(type: String) -> void:
	if type in unlocked_plants:
		selected_plant = type
		var all_btns = [flower_btn, bush_btn, star_btn, cactus_btn]
		var colors = {
			"flower": Color(1, 0.9, 0.3),
			"bush": Color(0.7, 1, 0.7),
			"star": Color(1, 0.95, 0.5),
			"cactus": Color(0.7, 1, 0.7)
		}
		for btn in all_btns:
			btn.modulate = Color(1, 1, 1, 1)
		match type:
			"flower": flower_btn.modulate = colors["flower"]
			"bush": bush_btn.modulate = colors["bush"]
			"star": star_btn.modulate = colors["star"]
			"cactus": cactus_btn.modulate = colors["cactus"]

func update_toolbar_for_level(available_plants: Array) -> void:
	unlocked_plants = available_plants if available_plants.size() > 0 else ["flower"]
	
	flower_btn.disabled = not "flower" in unlocked_plants
	bush_btn.disabled = not "bush" in unlocked_plants
	star_btn.disabled = not "star" in unlocked_plants
	cactus_btn.disabled = not "cactus" in unlocked_plants
	
	for btn in [flower_btn, bush_btn, star_btn, cactus_btn]:
		if btn.disabled:
			btn.modulate = Color(0.4, 0.4, 0.4, 0.5)
	
	selected_plant = "flower"
	if "flower" in unlocked_plants:
		select_plant("flower")
	elif unlocked_plants.size() > 0:
		select_plant(unlocked_plants[0])

func start_level(level_num: int) -> void:
	current_level = level_num
	var level_data = LevelManager.get_level(level_num)
	
	if level_data.is_empty():
		print("Level ", level_num, " not found!")
		return
	
	grid.setup(level_data)
	grid.selected_plant = selected_plant
	
	level_label.text = "Level %d" % level_num
	moves_label.text = "Moves: %d" % grid.max_moves
	grow_btn.disabled = true
	grow_btn.modulate = Color(0.6, 0.6, 0.6, 0.5)
	GameState.current_phase = GameState.PHASE.PLANT
	
	var available = level_data.get("available_plants", ["flower"])
	update_toolbar_for_level(available)
	
	if result_modal and is_instance_valid(result_modal):
		result_modal.queue_free()
		result_modal = null
	
	apply_biome_theme(level_data.get("biome", "meadow"))

func apply_biome_theme(biome: String) -> void:
	match biome:
		"meadow":
			$Background.color = Color(0.96, 0.94, 0.9)
			header.apply_dark_bar(false)
		"desert":
			$Background.color = Color(0.98, 0.9, 0.8)
			header.apply_dark_bar(false)
		"ocean":
			$Background.color = Color(0.85, 0.92, 0.95)
			header.apply_dark_bar(false)
		"space":
			$Background.color = Color(0.1, 0.08, 0.2)
			header.apply_dark_bar(true)
		"winter":
			$Background.color = Color(0.9, 0.95, 1.0)
			header.apply_dark_bar(false)

func _on_move_used() -> void:
	update_moves_label()
	var can_grow = grid.moves_used > 0
	grow_btn.disabled = not can_grow
	grow_btn.modulate = Color(1, 1, 1, 1) if can_grow else Color(0.6, 0.6, 0.6, 0.5)
	grid.selected_plant = selected_plant

func update_moves_label() -> void:
	var remaining = grid.get_moves_remaining()
	moves_label.text = "Moves: %d" % remaining
	if remaining <= 1:
		moves_label.add_theme_color_override("font_color", Color(0.9, 0.3, 0.3))
	else:
		moves_label.add_theme_color_override("font_color", Color(1, 1, 1))

func _on_grow() -> void:
	if GameState.current_phase != GameState.PHASE.PLANT:
		return
	grow_btn.disabled = true
	grow_btn.modulate = Color(0.6, 0.6, 0.6, 0.5)
	grid.grow_all_plants()

func _on_all_plants_grown(coverage: float) -> void:
	show_result(coverage)

func show_result(coverage: float) -> void:
	var stars = calculate_stars(coverage)
	
	result_modal = preload("res://scenes/ui/modal.tscn").instantiate()
	add_child(result_modal)
	
	if stars >= 1:
		result_modal.show_success(coverage, stars, true)
		result_modal.connect("next_pressed", _on_result_next)
		confetti.emit(get_viewport_rect().size / 2, 80 if stars == 3 else 40)
		LevelManager.complete_level(current_level, stars, coverage, grid.moves_used)
	else:
		result_modal.show_fail(coverage)
	
	result_modal.connect("retry_pressed", _on_result_retry)

func calculate_stars(coverage: float) -> int:
	var diff = abs(coverage - 100.0)
	if diff < 0.5:
		return 3
	elif diff < 10.0:
		return 2
	elif diff < 15.0:
		return 1
	return 0

func _on_result_retry() -> void:
	if result_modal and is_instance_valid(result_modal):
		result_modal.queue_free()
		result_modal = null
	_on_retry()

func _on_result_next() -> void:
	if result_modal and is_instance_valid(result_modal):
		result_modal.queue_free()
		result_modal = null
	GameState.current_level += 1
	start_level(GameState.current_level)

func _on_retry() -> void:
	grid.reset_grid()
	grow_btn.disabled = true
	grow_btn.modulate = Color(0.6, 0.6, 0.6, 0.5)
	update_moves_label()

func _on_pause() -> void:
	# TODO: Show pause menu
	pass

func _on_home() -> void:
	if result_modal and is_instance_valid(result_modal):
		result_modal.queue_free()
	get_tree().change_scene_to_file("res://scenes/screens/main_menu.tscn")
