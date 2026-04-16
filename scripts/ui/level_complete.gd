extends Control
class_name LevelComplete
## Level complete/victory panel with star rating and rewards

signal continue_pressed
signal close_pressed

@onready var stars: Control = $Panel/VBox/StarRating
@onready var status_banner: Label = $Panel/VBox/StatusBanner
@onready var reward_display: Control = $Panel/VBox/RewardDisplay
@onready var continue_button: Button = $Panel/VBox/ContinueButton
@onready var close_button: Button = $Panel/Header/CloseButton

var level_number: int = 1
var stars_earned: int = 0
var drops_reward: int = 0

func _ready() -> void:
	continue_button.pressed.connect(func(): AudioManager.sfx("click"); continue_pressed.emit())
	close_button.pressed.connect(func(): AudioManager.sfx("click"); close_pressed.emit())

func show_level(level: int, stars: int, reward: int) -> void:
	level_number = level
	stars_earned = stars
	drops_reward = reward
	
	status_banner.text = "LEVEL %d COMPLETE!" % level
	_show_stars(stars)
	_show_reward(reward)
	_modulate = Color(1, 1, 1, 0)
	visible = true

func _show_stars(count: int) -> void:
	# Animate stars appearing
	for i in range(3):
		var star = stars.get_child(i)
		star.set_filled(i < count)
		if i < count:
			star.animate_fill()

func _show_reward(amount: int) -> void:
	reward_display.set_drops(amount)

func animate_in() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.3)
	tween.tween_interval(0.2)
	# Stars animate one by one
	
func animate_out() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	await tween.finished
	visible = false
