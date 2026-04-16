extends Node

var all_levels: Array = []

func _ready() -> void:
	load_levels()

func load_levels() -> void:
	var file = FileAccess.open("res://resources/levels/levels.json", FileAccess.READ)
	if file:
		var json_str = file.get_as_text()
		var json = JSON.new()
		var parse_result = json.parse(json_str)
		if parse_result == OK:
			all_levels = json.get_data()
		file.close()

func get_level(id: int) -> Dictionary:
	if id > 0 and id <= all_levels.size():
		return all_levels[id - 1]
	return {}

func get_total_levels() -> int:
	return all_levels.size()

func is_unlocked(id: int) -> bool:
	if id <= 1:
		return true
	var prev_id = str(id - 1)
	var progress = SaveManager.save_data.get("level_progress", {}).get(prev_id, {})
	return progress.get("completed", false)

func get_stars(level_id: int) -> int:
	var lid = str(level_id)
	var progress = SaveManager.save_data.get("level_progress", {}).get(lid, {})
	return progress.get("stars", 0)

func complete_level(level_id: int, stars: int, coverage: float, moves_used: int) -> void:
	var lid = str(level_id)
	var progress = SaveManager.save_data.get("level_progress", {})
	
	var existing = progress.get(lid, {})
	var existing_stars = existing.get("stars", 0)
	
	progress[lid] = {
		"completed": true,
		"stars": max(existing_stars, stars),
		"coverage": coverage,
		"moves_used": moves_used,
		"best_moves": existing.get("best_moves", moves_used)
	}
	
	SaveManager.save_data["level_progress"] = progress
	
	# Update stats
	var stats = SaveManager.save_data.get("stats", {})
	stats["levels_completed"] = stats.get("levels_completed", 0) + 1
	stats["total_stars"] = SaveManager.save_data["unlocks"].get("total_stars", 0)
	SaveManager.save_data["stats"] = stats
	
	SaveManager.save_game()
	
	# Check unlocks
	check_unlocks(level_id, stars)

func check_unlocks(level_id: int, stars: int) -> void:
	var unlocks = SaveManager.save_data.get("unlocks", {})
	var plants = unlocks.get("plants", ["flower"])
	var biomes = unlocks.get("biomes", ["meadow"])
	
	# Unlock plants at 3-star milestones
	if stars >= 3:
		if level_id >= 6 and not "bush" in plants:
			plants.append("bush")
		if level_id >= 15 and not "star" in plants:
			plants.append("star")
		if level_id >= 25 and not "cactus" in plants:
			plants.append("cactus")
	
	# Unlock biomes at section completion
	if level_id >= 20 and not "desert" in biomes:
		biomes.append("desert")
	if level_id >= 40 and not "ocean" in biomes:
		biomes.append("ocean")
	if level_id >= 60 and not "space" in biomes:
		biomes.append("space")
	if level_id >= 80 and not "winter" in biomes:
		biomes.append("winter")
	
	unlocks["plants"] = plants
	unlocks["biomes"] = biomes
	SaveManager.save_data["unlocks"] = unlocks
