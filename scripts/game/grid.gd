extends Node2D

signal plant_placed(x: int, y: int)
signal all_plants_grown(coverage: float)
signal move_used()

const CELL_SIZE: int = 80
const CELL_GAP: int = 4

var grid_size: int = 5
var cells: Array = []
var max_moves: int = 5
var moves_used: int = 0
var level_data: Dictionary = {}
var available_plants: Array = ["flower"]
var selected_plant: String = "flower"

# Plant coverage mapping (simplified - circular approximation)
const PLANT_COVERAGE: Dictionary = {
	"flower": 1,   # radius
	"bush": 2,
	"star": 2,
	"cactus": 1
}

# Plant type indices for PlantAnimator
const PLANT_TYPE_MAP: Dictionary = {
	"flower": 0,  # FLOWER
	"bush": 1,    # BUSH
	"star": 2,    # STAR
	"cactus": 3   # CACTUS
}

var planted_seeds: Array = []  # Array of {x, y, plant_type}

func setup(level: Dictionary) -> void:
	level_data = level
	grid_size = level.get("grid_size", 5)
	max_moves = level.get("max_moves", 5)
	available_plants = level.get("available_plants", ["flower"])
	moves_used = 0
	planted_seeds.clear()
	
	# Clear existing cells
	for row in cells:
		for cell in row:
			if cell and is_instance_valid(cell):
				cell.queue_free()
	cells.clear()
	
	# Create grid
	for y in range(grid_size):
		var row: Array = []
		for x in range(grid_size):
			var cell_scene = preload("res://scenes/game/cell.tscn")
			var cell = cell_scene.instantiate()
			add_child(cell)
			cell.position = Vector2(x * (CELL_SIZE + CELL_GAP), y * (CELL_SIZE + CELL_GAP))
			cell.cell_x = x
			cell.cell_y = y
			if cell.connect("cell_tapped", _on_cell_tapped) != OK:
				pass
			row.append(cell)
		cells.append(row)
	
	# Setup obstacles
	var obstacles = level.get("obstacles", [])
	for obs in obstacles:
		var ox = obs.get("x", 0)
		var oy = obs.get("y", 0)
		var obs_type = obs.get("type", "rock")
		
		if oy < cells.size() and oy >= 0 and ox < cells[oy].size() and ox >= 0:
			var terrain_type = Cell.Terrain.WATER if obs_type == "water" else Cell.Terrain.ROCK
			cells[oy][ox].set_terrain(terrain_type)
	
	# Center the grid
	var grid_width = grid_size * (CELL_SIZE + CELL_GAP) - CELL_GAP
	var grid_height = grid_size * (CELL_SIZE + CELL_GAP) - CELL_GAP
	offset = -Vector2(grid_width, grid_height) / 2

func _on_cell_tapped(x: int, y: int) -> void:
	if GameState.current_phase != GameState.PHASE.PLANT:
		return
	if moves_used >= max_moves:
		return
	
	var cell = cells[y][x]
	if cell.has_seed or cell.terrain == Cell.Terrain.ROCK or cell.terrain == Cell.Terrain.VOID:
		return
	
	# Use selected plant type
	var plant_type = selected_plant if selected_plant in available_plants else available_plants[0]
	cell.place_seed()
	planted_seeds.append({"x": x, "y": y, "plant_type": plant_type})
	moves_used += 1
	emit_signal("move_used")
	emit_signal("plant_placed", x, y)
	
	# Play sound (will work once audio is set up)
	# AudioManager.play_sfx("plant")

func grow_all_plants() -> void:
	GameState.current_phase = GameState.PHASE.GROW
	
	# Calculate which cells get covered
	var coverage: Dictionary = {}  # key = "x,y", value = true
	
	for seed in planted_seeds:
		var px = seed.x
		var py = seed.y
		var plant_type_str = seed.plant_type
		var radius = PLANT_COVERAGE.get(plant_type_str, 1)
		var plant_anim_type = PLANT_TYPE_MAP.get(plant_type_str, 0)
		
		# Mark cells in radius as covered
		for dy in range(-radius, radius + 1):
			for dx in range(-radius, radius + 1):
				var nx = px + dx
				var ny = py + dy
				if nx >= 0 and nx < grid_size and ny >= 0 and ny < grid_size:
					var target_cell = cells[ny][nx]
					if target_cell.terrain != Cell.Terrain.ROCK:
						coverage[str(nx) + "," + str(ny)] = true
	
	# Animate growth
	var delay = 0.0
	for seed in planted_seeds:
		var px = seed.x
		var py = seed.y
		var cell = cells[py][px]
		var plant_anim_type = PLANT_TYPE_MAP.get(seed.plant_type, 0)
		
		await get_tree().create_timer(delay).timeout
		cell.grow_plant(plant_anim_type)
		delay += 0.1
	
	# Wait for growth animation then show result
	await get_tree().create_timer(1.8).timeout
	finish_growth(coverage)

func finish_growth(coverage: Dictionary) -> void:
	# Count cells
	var total_terrain_cells = 0
	var covered_cells = 0
	
	for y in range(grid_size):
		for x in range(grid_size):
			var cell = cells[y][x]
			if cell.terrain != Cell.Terrain.ROCK and cell.terrain != Cell.Terrain.VOID:
				total_terrain_cells += 1
				if coverage.has(str(x) + "," + str(y)):
					covered_cells += 1
	
	var coverage_pct = (covered_cells * 100.0) / total_terrain_cells if total_terrain_cells > 0 else 0.0
	
	GameState.current_phase = GameState.PHASE.RESULT
	emit_signal("all_plants_grown", coverage_pct)

func get_moves_remaining() -> int:
	return max_moves - moves_used

func reset_grid() -> void:
	moves_used = 0
	planted_seeds.clear()
	GameState.current_phase = GameState.PHASE.PLANT
	
	for y in range(grid_size):
		for x in range(grid_size):
			if y < cells.size() and x < cells[y].size() and cells[y][x]:
				cells[y][x].reset()
