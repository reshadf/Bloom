extends Control
class_name SettingsPanel
## Settings panel - sound, music, notifications, account

signal closed
signal sound_changed(enabled: bool)
signal music_changed(enabled: bool)
signal notifications_changed(enabled: bool)

@onready var sound_toggle: CheckButton = $Panel/VBox/SoundRow/SoundToggle
@onready var music_toggle: CheckButton = $Panel/VBox/MusicRow/MusicToggle
@onready var notify_toggle: CheckButton = $Panel/VBox/NotifyRow/NotifyToggle
@onready var close_button: Button = $Panel/Header/CloseButton

var sound_enabled: bool = true
var music_enabled: bool = true
var notifications_enabled: bool = true

func _ready() -> void:
	sound_toggle.toggled.connect(func(v): sound_changed.emit(v))
	music_toggle.toggled.connect(func(v): music_changed.emit(v))
	notify_toggle.toggled.connect(func(v): notifications_changed.emit(v))
	close_button.pressed.connect(func(): AudioManager.sfx("click"); close())

func open() -> void:
	visible = true
	sound_toggle.button_pressed = sound_enabled
	music_toggle.button_pressed = music_enabled
	notify_toggle.button_pressed = notifications_enabled

func close() -> void:
	closed.emit()
	visible = false
