extends Node

const SAVE_PATH = "user://save_game.json"

var save_data: Dictionary = {
	"version": "1.0",
	"level_progress": {},
	"unlocks": {},
	"settings": {},
	"stats": {}
}

func save_game() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var json_str = JSON.stringify(save_data, "\t")
		file.store_string(json_str)
		file.close()

func load_game() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var json_str = file.get_as_text()
			var json = JSON.new()
			var parse_result = json.parse(json_str)
			if parse_result == OK:
				save_data = json.get_data()
			file.close()
	else:
		# First run - initialize defaults
		save_data = {
			"version": "1.0",
			"level_progress": {},
			"unlocks": {
				"plants": ["flower"],
				"biomes": ["meadow"],
				"themes": ["meadow"],
				"no_ads": false
			},
			"settings": {
				"music_volume": 0.8,
				"sfx_volume": 1.0,
				"haptics": true
			},
			"stats": {
				"total_stars": 0,
				"levels_completed": 0,
				"play_time": 0.0
			}
		}
		save_game()

func reset_save() -> void:
	save_data = {
		"version": "1.0",
		"level_progress": {},
		"unlocks": {
			"plants": ["flower"],
			"biomes": ["meadow"],
			"themes": ["meadow"],
			"no_ads": false
		},
		"settings": {
			"music_volume": 0.8,
			"sfx_volume": 1.0,
			"haptics": true
		},
		"stats": {
			"total_stars": 0,
			"levels_completed": 0,
			"play_time": 0.0
		}
	}
	save_game()
