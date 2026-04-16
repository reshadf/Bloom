extends HBoxContainer

@export var num_stars: int = 3
@export var star_size: int = 48
@export var animate_on_show: bool = true

var stars_earned: int = 0

@onready var star_labels: Array = []

func _ready() -> void:
	# Get all star labels
	for i in range(1, 4):
		var star = get_node_or_null("Star" + str(i))
		if star:
			star_labels.append(star)
			if star is Label:
				star.add_theme_font_size_override("font_size", star_size)
	
	reset_stars()

func set_stars(count: int) -> void:
	stars_earned = clamp(count, 0, num_stars)
	
	if animate_on_show:
		animate_stars()
	else:
		update_immediately()

func animate_stars() -> void:
	for i in range(num_stars):
		if i < star_labels.size():
			var star = star_labels[i]
			if star is Label:
				var delay = i * 0.25
				await get_tree().create_timer(delay).timeout
				
				# Animate
				var tween = create_tween()
				tween.set_parallel(true)
				
				if i < stars_earned:
					star.text = "⭐"
					tween.tween_property(star, "scale", Vector2(1.5, 1.5), 0.1)
					tween.tween_callback(star.add_theme_color_override.bind("font_color", Color(1, 0.85, 0.2)))
					tween.tween_callback(func(): tween.tween_property(star, "scale", Vector2(1.0, 1.0), 0.1))
				else:
					star.text = "☆"
					star.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))

func update_immediately() -> void:
	for i in range(num_stars):
		if i < star_labels.size():
			var star = star_labels[i]
			if star is Label:
				if i < stars_earned:
					star.text = "⭐"
					star.add_theme_color_override("font_color", Color(1, 0.85, 0.2))
				else:
					star.text = "☆"
					star.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))

func reset_stars() -> void:
	stars_earned = 0
	for star in star_labels:
		if star is Label:
			star.text = "☆"
			star.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
			star.scale = Vector2.ONE
