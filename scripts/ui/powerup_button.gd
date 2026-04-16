extends Button

enum PowerUpType { HINT, UNDO, BOOST }

@export var power_type: PowerUpType = PowerUpType.HINT
@export var uses_remaining: int = -1  # -1 = unlimited

signal powerup_used(type: PowerUpType)

func _ready() -> void:
	pressed.connect(_on_pressed)
	update_display()

func setup(p_type: PowerUpType, uses: int = -1) -> void:
	power_type = p_type
	uses_remaining = uses
	update_display()

func _on_pressed() -> void:
	if uses_remaining != 0:
		powerup_used.emit(power_type)
		if uses_remaining > 0:
			uses_remaining -= 1
			update_display()

func update_display() -> void:
	match power_type:
		PowerUpType.HINT:
			text = "💡"
		PowerUpType.UNDO:
			text = "↩️"
		PowerUpType.BOOST:
			text = "🚀"
	
	# Uses badge
	if uses_remaining >= 0:
		tooltip_text = "%d uses left" % uses_remaining
		if uses_remaining == 0:
			disabled = true
			modulate = Color(0.4, 0.4, 0.4, 0.5)
	else:
		tooltip_text = "Unlimited"
		disabled = false
		modulate = Color(1, 1, 1, 1)
