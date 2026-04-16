extends Button

@onready var level_number: Label = $LevelNumber
@onready var stars_label: Label = $Stars

var level_num: int = 1

func setup(num: int, stars: int, unlocked: bool) -> void:
	level_num = num
	level_number.text = str(num)
	stars_label.text = "⭐".repeat(stars) if stars > 0 else ""
	
	if not unlocked:
		disabled = true
		modulate = Color(0.5, 0.5, 0.5, 0.5)
		stars_label.text = "🔒"
	else:
		disabled = false
		modulate = Color(1, 1, 1, 1)
