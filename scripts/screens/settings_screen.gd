extends CanvasLayer

@onready var back_button: Button = $TopBar/BackButton
@onready var sound_slider: HSlider = $VBox/SoundRow/SoundSlider
@onready var music_slider: HSlider = $VBox/MusicRow/MusicSlider
@onready var haptics_check: CheckButton = $VBox/HapticsRow/HapticsCheck

func _ready() -> void:
	back_button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/screens/main_menu.tscn"))
	
	# Load current settings
	sound_slider.value = GameState.sfx_volume
	music_slider.value = GameState.music_volume
	haptics_check.button_pressed = GameState.haptics_enabled
	
	sound_slider.value_changed.connect(_on_sound_changed)
	music_slider.value_changed.connect(_on_music_changed)
	haptics_check.toggled.connect(_on_haptics_toggled)

func _on_sound_changed(value: float) -> void:
	GameState.sfx_volume = value
	AudioManager.set_sfx_volume(value)
	SaveManager.save_game()

func _on_music_changed(value: float) -> void:
	GameState.music_volume = value
	AudioManager.set_music_volume(value)
	SaveManager.save_game()

func _on_haptics_toggled(pressed: bool) -> void:
	GameState.haptics_enabled = pressed
	SaveManager.save_game()
