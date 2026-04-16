extends Control
class_name PlayWidget
## Play widget - mini preview with quick play button

signal play_pressed

@onready var preview: Control = $PreviewContainer
@onready var play_button: Button = $PlayButton
@onready var level_label: Label = $LevelLabel

var level_number: int = 1

func _ready() -> void:
	play_button.pressed.connect(func(): AudioManager.sfx("click"); play_pressed.emit())

func set_level(num: int) -> void:
	level_number = num
	level_label.text = "Level %d" % num
	# TODO: Update preview with level thumbnail

func set_preview_texture(tex: Texture2D) -> void:
	preview.get_child(0).texture = tex
