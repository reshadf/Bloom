extends HBoxContainer

signal plant_selected(plant_type: String)

@onready var flower_btn: Button = $FlowerBtn
@onready var bush_btn: Button = $BushBtn
@onready var star_btn: Button = $StarBtn
@onready var cactus_btn: Button = $CactusBtn

var selected_plant: String = "flower"
var unlocked_plants: Array = ["flower"]

func _ready() -> void:
	flower_btn.pressed.connect(func(): select_plant("flower"))
	bush_btn.pressed.connect(func(): select_plant("bush"))
	star_btn.pressed.connect(func(): select_plant("star"))
	cactus_btn.pressed.connect(func(): select_plant("cactus"))
	
	update_buttons()

func set_unlocked_plants(plants: Array) -> void:
	unlocked_plants = plants
	update_buttons()

func update_buttons() -> void:
	flower_btn.disabled = not "flower" in unlocked_plants
	bush_btn.disabled = not "bush" in unlocked_plants
	star_btn.disabled = not "star" in unlocked_plants
	cactus_btn.disabled = not "cactus" in unlocked_plants
	
	# Highlight selected
	flower_btn.modulate = Color(1, 1, 1, 1) if selected_plant == "flower" else Color(0.6, 0.6, 0.6, 1)
	bush_btn.modulate = Color(1, 1, 1, 1) if selected_plant == "bush" else Color(0.6, 0.6, 0.6, 1)
	star_btn.modulate = Color(1, 1, 1, 1) if selected_plant == "star" else Color(0.6, 0.6, 0.6, 1)
	cactus_btn.modulate = Color(1, 1, 1, 1) if selected_plant == "cactus" else Color(0.6, 0.6, 0.6, 1)

func select_plant(type: String) -> void:
	if type in unlocked_plants:
		selected_plant = type
		update_buttons()
		emit_signal("plant_selected", type)

func get_selected_plant() -> String:
	return selected_plant
