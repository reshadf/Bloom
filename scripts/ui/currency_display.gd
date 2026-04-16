extends Control
class_name CurrencyDisplay
## Water drop currency display (used in header bars)

signal tapped

@onready var icon: TextureRect = $Icon
@onready var amount_label: Label = $AmountLabel

var amount: int = 0

func _ready() -> void:
	gui_input.connect(func(e): 
		if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT:
			tapped.emit()
	)

func set_drops(value: int, animate: bool = true) -> void:
	var old = amount
	amount = value
	amount_label.text = str(value)
	
	if animate and value > old:
		_animate_gain(value - old)

func add_drops(value: int) -> void:
	set_drops(amount + value)

func _animate_gain(delta: int) -> void:
	var tween = create_tween()
	tween.tween_property(amount_label, "scale", Vector2(1.3, 1.3), 0.1)
	tween.tween_property(amount_label, "scale", Vector2(1.0, 1.0), 0.1)
	amount_label.modulate = Color("FFD700")
	tween.tween_property(amount_label, "modulate", Color.WHITE, 0.3)
