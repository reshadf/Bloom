extends Node2D

@export var num_stars: int = 3
@export var star_spacing: float = 60.0
@export var star_size: float = 48.0

var stars_earned: int = 0
var star_nodes: Array = []

func _ready() -> void:
	create_stars()

func create_stars() -> void:
	for i in range(num_stars):
		var star = TextureRect.new()
		star.custom_minimum_size = Vector2(star_size, star_size)
		star.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		star.modulate = Color(0.3, 0.3, 0.3)  # Grayed out initially
		add_child(star)
		star_nodes.append(star)
	
	# Center the stars
	var total_width = num_stars * star_spacing
	for i in range(num_stars):
		star_nodes[i].position.x = i * star_spacing - total_width / 2 + star_spacing / 2

func set_stars(count: int) -> void:
	stars_earned = count
	animate_stars()

func animate_stars() -> void:
	for i in range(num_stars):
		var star = star_nodes[i]
		var delay = i * 0.3  # Stagger animation
		
		if i < stars_earned:
			# Animate to filled
			var tween = create_tween()
			tween.tween_interval(delay)
			tween.tween_property(star, "modulate", Color(1, 0.85, 0.2, 1), 0.15)  # Gold
			tween.tween_property(star, "scale", Vector2(1.4, 1.4), 0.1)
			tween.tween_property(star, "scale", Vector2(1.0, 1.0), 0.1)
		else:
			# Stay gray
			star.modulate = Color(0.3, 0.3, 0.3)

func reset() -> void:
	stars_earned = 0
	for star in star_nodes:
		star.modulate = Color(0.3, 0.3, 0.3)
		star.scale = Vector2.ONE
