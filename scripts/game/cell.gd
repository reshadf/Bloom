extends PanelContainer

signal cell_tapped(x: int, y: int)

@export var cell_x: int = 0
@export var cell_y: int = 0

enum Terrain { GRASS, WATER, ROCK, WEED, VOID }
enum PlantState { EMPTY, SEED, GROWING, GROWN }

var terrain: Terrain = Terrain.GRASS
var plant_state: PlantState = PlantState.EMPTY
var has_seed: bool = false
var is_covered: bool = false
var current_plant: Node = null

@onready var bg: ColorRect = $Background
@onready var seed_indicator: ColorRect = $SeedIndicator
@onready var plant_container: Node2D = $PlantContainer

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	update_terrain_appearance()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			# Don't allow tap on rocks
			if terrain == Terrain.ROCK or terrain == Terrain.VOID:
				return
			emit_signal("cell_tapped", cell_x, cell_y)

func set_terrain(t: Terrain) -> void:
	terrain = t
	update_terrain_appearance()

func update_terrain_appearance() -> void:
	match terrain:
		Terrain.GRASS:
			bg.color = Color(0.6, 0.8, 0.5, 1)
		Terrain.WATER:
			bg.color = Color(0.4, 0.7, 0.9, 1)
		Terrain.ROCK:
			bg.color = Color(0.45, 0.45, 0.45, 1)
		Terrain.WEED:
			bg.color = Color(0.5, 0.6, 0.3, 1)
		Terrain.VOID:
			bg.color = Color(0.2, 0.2, 0.2, 0.3)

func place_seed() -> void:
	has_seed = true
	plant_state = PlantState.SEED
	seed_indicator.visible = true
	
	# Pulse animation
	var tween = create_tween()
	tween.set_loops(3)
	tween.tween_property(seed_indicator, "modulate:a", 0.5, 0.3)
	tween.tween_property(seed_indicator, "modulate:a", 1.0, 0.3)

func grow_plant(plant_type: int = 0) -> void:
	has_seed = false
	plant_state = PlantState.GROWING
	seed_indicator.visible = false
	is_covered = true
	
	# Create plant animator
	var animator = preload("res://scripts/game/plant_animator.gd").new()
	animator.plant_type = plant_type
	plant_container.add_child(animator)
	current_plant = animator
	
	animator.grow()

func reset() -> void:
	has_seed = false
	plant_state = PlantState.EMPTY
	is_covered = false
	seed_indicator.visible = false
	
	if current_plant:
		current_plant.queue_free()
		current_plant = null
	
	# Clear any remaining children
	for child in plant_container.get_children():
		child.queue_free()
