extends Node2D

enum PlantType { FLOWER, BUSH, STAR, CACTUS }

@export var plant_type: PlantType = PlantType.FLOWER
@export var growth_duration: float = 1.0

var is_growing: bool = false

# Visual components (simple shapes)
var flower_sprite: Sprite2D
var bush_sprite: Sprite2D
var star_sprite: Sprite2D
var cactus_sprite: Sprite2D

func _ready() -> void:
	scale = Vector2.ZERO
	create_plant_visuals()

func create_plant_visuals() -> void:
	# Create simple colored circles/shapes for each plant type
	# Using a simple approach - create shapes as children
	
	match plant_type:
		PlantType.FLOWER:
			create_flower()
		PlantType.BUSH:
			create_bush()
		PlantType.STAR:
			create_star()
		PlantType.CACTUS:
			create_cactus()

func create_flower() -> void:
	# Center (yellow)
	var center = ColorRect.new()
	center.custom_minimum_size = Vector2(16, 16)
	center.color = Color(1, 0.9, 0.3)
	add_child(center)
	
	# Petals (pink circles)
	for i in range(5):
		var petal = ColorRect.new()
		petal.custom_minimum_size = Vector2(14, 14)
		petal.color = Color(1, 0.7, 0.85)
		petal.position = Vector2(cos(i * TAU / 5) * 18 - 7, sin(i * TAU / 5) * 18 - 7)
		add_child(petal)

func create_bush() -> void:
	# Main green circle
	var main = ColorRect.new()
	main.custom_minimum_size = Vector2(40, 40)
	main.color = Color(0.4, 0.8, 0.4)
	add_child(main)
	
	# Smaller leaves around
	for i in range(6):
		var leaf = ColorRect.new()
		leaf.custom_minimum_size = Vector2(16, 16)
		leaf.color = Color(0.35, 0.7, 0.35)
		var angle = i * TAU / 6
		leaf.position = Vector2(cos(angle) * 22 - 8, sin(angle) * 22 - 8)
		add_child(leaf)

func create_star() -> void:
	# Star shape using Polygon2D
	var star = Polygon2D.new()
	var points = PackedVector2Array()
	for i in range(10):
		var angle = (TAU / 10) * i - PI/2
		var r = 20 if i % 2 == 0 else 10
		points.append(Vector2(cos(angle) * r, sin(angle) * r))
	star.polygon = points
	star.color = Color(1, 0.9, 0.3)
	add_child(star)
	
	# Center glow
	var glow = ColorRect.new()
	glow.custom_minimum_size = Vector2(10, 10)
	glow.color = Color(1, 1, 0.8, 0.8)
	add_child(glow)

func create_cactus() -> void:
	# Main body
	var body = ColorRect.new()
	body.custom_minimum_size = Vector2(14, 40)
	body.color = Color(0.5, 0.8, 0.5)
	body.position = Vector2(-7, -20)
	add_child(body)
	
	# Left arm
	var left_arm = ColorRect.new()
	left_arm.custom_minimum_size = Vector2(12, 8)
	left_arm.color = Color(0.5, 0.8, 0.5)
	left_arm.position = Vector2(-18, -8)
	add_child(left_arm)
	
	# Right arm
	var right_arm = ColorRect.new()
	right_arm.custom_minimum_size = Vector2(12, 8)
	right_arm.color = Color(0.5, 0.8, 0.5)
	right_arm.position = Vector2(6, -12)
	add_child(right_arm)

func grow(completed_callback: Callable = func(): pass) -> void:
	if is_growing:
		return
	is_growing = true
	
	# Animate scale up with bounce
	var tween = create_tween()
	tween.set_parallel(true)
	
	# Scale with bounce effect
	tween.tween_property(self, "scale", Vector2.ONE, growth_duration)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	# Slight rotation wobble
	var rot_tween = create_tween()
	rot_tween.set_loops(3)
	rot_tween.tween_property(self, "rotation", 0.1, 0.2)
	rot_tween.tween_property(self, "rotation", -0.1, 0.2)
	
	# Complete
	tween.tween_callback(completed_callback)
	tween.tween_callback(func(): is_growing = false)

func _draw() -> void:
	# Drawing is handled by child nodes now
	pass
