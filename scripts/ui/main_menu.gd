extends Control
class_name MainMenu
## Main menu screen - logo, play button, daily rewards, level/store/settings buttons

signal play_pressed
signal levels_pressed
signal store_pressed
signal settings_pressed

@onready var play_button: Button = $VBox/PlayButton
@onready var levels_button: Button = $VBox/ButtonRow/LevelsButton
@onready var store_button: Button = $VBox/ButtonRow/StoreButton
@onready var settings_button: Button = $VBox/ButtonRow/SettingsButton
@onready var daily_rewards: Control = $VBox/DailyRewards

func _ready() -> void:
	play_button.pressed.connect(func(): AudioManager.sfx("click"); play_pressed.emit())
	levels_button.pressed.connect(func(): AudioManager.sfx("click"); levels_pressed.emit())
	store_button.pressed.connect(func(): AudioManager.sfx("click"); store_pressed.emit())
	settings_button.pressed.connect(func(): AudioManager.sfx("click"); settings_pressed.emit())

func show_daily_reward(day: int = 1, can_claim: bool = true) -> void:
	daily_rewards.visible = true
	# Update reward day highlight

func _on_play_pressed():
	play_pressed.emit()
