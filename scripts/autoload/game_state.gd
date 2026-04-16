extends Node

# Current level progress
var current_level: int = 1
var total_stars: int = 0

# Unlocked content
var unlocked_plants: Array = ["flower"]
var unlocked_biomes: Array = ["meadow"]
var equipped_theme: String = "meadow"
var equipped_plant_colors: String = "default"

# Player stats
var levels_completed: int = 0
var total_play_time: float = 0.0

# Settings
var music_volume: float = 0.8
var sfx_volume: float = 1.0
var haptics_enabled: bool = true

# Game phases
enum PHASE { PLANT, GROW, RESULT }
var current_phase: PHASE = PHASE.PLANT

func _ready() -> void:
	SaveManager.load_game()

func save_state() -> void:
	SaveManager.save_game()

func reset_progress() -> void:
	current_level = 1
	total_stars = 0
	levels_completed = 0
	total_play_time = 0.0
	unlocked_plants = ["flower"]
	unlocked_biomes = ["meadow"]
