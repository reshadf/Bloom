extends Button

enum PlantType { FLOWER, BUSH, STAR, CACTUS }

@export var plant_type: PlantType = PlantType.FLOWER
@export var is_selected: bool = false
@export var is_locked: bool = false

signal plant_chosen(type: PlantType)

func _ready() -> void:
	pressed.connect(_on_pressed)
	update_display()

func setup(type: PlantType, selected: bool, locked: bool) -> void:
	plant_type = type
	is_selected = selected
	is_locked = locked
	update_display()

func _on_pressed() -> void:
	if not is_locked:
		plant_chosen.emit(plant_type)

func update_display() -> void:
	# Icon
	match plant_type:
		PlantType.FLOWER:
			text = "🌸"
		PlantType.BUSH:
			text = "🌿"
		PlantType.STAR:
			text = "⭐"
		PlantType.CACTUS:
			text = "🌵"
	
	# Visual state
	if is_locked:
		modulate = Color(0.4, 0.4, 0.4, 0.5)
		disabled = true
	elif is_selected:
		modulate = Color(1, 0.9, 0.3)  # Gold highlight
	else:
		modulate = Color(1, 1, 1, 1)
