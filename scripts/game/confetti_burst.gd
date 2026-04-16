extends Node2D

const CONFETTI_COLORS: Array = [
	Color(1, 0.85, 0.2),    # Gold
	Color(1, 0.5, 0.5),      # Pink
	Color(0.5, 0.8, 0.5),    # Green
	Color(0.5, 0.5, 1),      # Blue
	Color(1, 0.7, 0.3),      # Orange
]

var particles: Array = []
var is_emitting: bool = false

class ConfettiParticle:
	var pos: Vector2
	var vel: Vector2
	var color: Color
	var size: float
	var rotation: float
	var rotation_speed: float
	var lifetime: float
	var age: float
	
	func _init(p: Vector2, v: Vector2, c: Color):
		pos = p
		vel = v
		color = c
		size = randf_range(4, 10)
		rotation = randf() * 360
		rotation_speed = randf_range(-360, 360)
		lifetime = randf_range(2.0, 3.5)
		age = 0.0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func emit(from_pos: Vector2, count: int = 50) -> void:
	is_emitting = true
	global_position = from_pos
	
	for i in range(count):
		var angle = randf() * TAU
		var speed = randf_range(200, 500)
		var vel = Vector2(cos(angle), sin(angle)) * speed
		vel.y -= 200  # Bias upward
		var color = CONFETTI_COLORS[randi() % CONFETTI_COLORS.size()]
		particles.append(ConfettiParticle.new(Vector2.ZERO, vel, color))
	
	is_emitting = true

func _process(delta: float) -> void:
	if not is_emitting:
		return
	
	queue_redraw()
	
	for p in particles:
		p.age += delta
		if p.age >= p.lifetime:
			continue
		
		p.vel.y += 400 * delta  # Gravity
		p.pos += p.vel * delta
		p.rotation += p.rotation_speed * delta
	
	# Remove dead particles
	particles = particles.filter(func(p): return p.age < p.lifetime)
	
	if particles.is_empty():
		is_emitting = false

func _draw() -> void:
	for p in particles:
		if p.age >= p.lifetime:
			continue
		var alpha = 1.0 - (p.age / p.lifetime)
		var c = p.color
		c.a = alpha
		draw_set_transform(p.pos, deg_to_rad(p.rotation))
		draw_rect(Rect2(-p.size/2, -p.size/2, p.size, p.size * 0.6), c)
	draw_set_transform(Vector2.ZERO, 0)
