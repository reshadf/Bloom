extends CanvasLayer

signal retry_pressed()
signal next_pressed()
signal closed()

@onready var overlay: Panel = $Overlay
@onready var card: PanelContainer = $Card/VBox
@onready var title_label: Label = $Card/VBox/Title
@onready var message_label: Label = $Card/VBox/Content/Message
@onready var stars_container: HBoxContainer = $Card/VBox/Content/Stars
@onready var retry_btn: Button = $Card/VBox/Buttons/RetryButton
@onready var next_btn: Button = $Card/VBox/Buttons/NextButton

var is_success: bool = true

func _ready() -> void:
	retry_btn.pressed.connect(func(): emit_signal("retry_pressed"))
	next_btn.pressed.connect(func(): emit_signal("next_pressed"))

func show_success(coverage: float, stars: int, show_next: bool = true) -> void:
	is_success = true
	
	title_label.text = "Level Complete!"
	message_label.text = "You covered %d%%!" % coverage
	
	# Setup stars display
	stars_container.get_children().clear()
	for i in range(3):
		var star = Label.new()
		star.text = "☆" if i >= stars else "⭐"
		star.add_theme_font_size_override("font_size", 56)
		star.add_theme_color_override("font_color", Color(1, 0.85, 0.2) if i < stars else Color(0.5, 0.5, 0.5))
		star.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		stars_container.add_child(star)
	
	next_btn.visible = show_next
	next_btn.disabled = not show_next
	
	animate_in()

func show_fail(coverage: float) -> void:
	is_success = false
	
	title_label.text = "Try Again!"
	message_label.text = "You covered %d%%.\nNeed exactly 100%%!" % coverage
	
	# No stars for fail
	stars_container.get_children().clear()
	var empty = Label.new()
	empty.text = "💪"
	empty.add_theme_font_size_override("font_size", 48)
	empty.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stars_container.add_child(empty)
	
	next_btn.visible = false
	
	animate_in()

func animate_in() -> void:
	modulate.a = 0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.3)
	
	# Card scale animation
	card.scale = Vector2(0.8, 0.8)
	var card_tween = create_tween()
	card_tween.tween_property(card, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_BACK)

func animate_out(on_complete: Callable = func(): pass) -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	await tween.finished
	on_complete.call()
	queue_free()
