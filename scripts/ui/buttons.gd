extends Button

enum ButtonType { PRIMARY, SECONDARY, ICON }

@export var button_type: ButtonType = ButtonType.PRIMARY

func _ready() -> void:
	apply_style()

func apply_style() -> void:
	match button_type:
		ButtonType.PRIMARY:
			add_theme_stylebox_override("normal", create_primary_normal())
			add_theme_stylebox_override("hover", create_primary_hover())
			add_theme_stylebox_override("pressed", create_primary_pressed())
		ButtonType.SECONDARY:
			add_theme_stylebox_override("normal", create_secondary_normal())
			add_theme_stylebox_override("hover", create_secondary_hover())
			add_theme_stylebox_override("pressed", create_secondary_pressed())
		ButtonType.ICON:
			add_theme_stylebox_override("normal", create_icon_normal())
			add_theme_stylebox_override("hover", create_icon_hover())
			add_theme_stylebox_override("pressed", create_icon_pressed())

func create_primary_normal() -> StyleBoxFlat:
	var s = StyleBoxFlat.new()
	s.bg_color = Color(1, 0.718, 0.302, 1)  # Gold
	s.corner_radius_top_left = 30
	s.corner_radius_top_right = 30
	s.corner_radius_bottom_left = 30
	s.corner_radius_bottom_right = 30
	s.shadow_color = Color(0, 0, 0, 0.3)
	s.shadow_size = 4
	return s

func create_primary_hover() -> StyleBoxFlat:
	var s = create_primary_normal()
	s.bg_color = Color(1, 0.8, 0.4)
	return s

func create_primary_pressed() -> StyleBoxFlat:
	var s = create_primary_normal()
	s.bg_color = Color(0.9, 0.6, 0.2)
	s.shadow_size = 2
	return s

func create_secondary_normal() -> StyleBoxFlat:
	var s = StyleBoxFlat.new()
	s.bg_color = Color(0.96, 0.94, 0.9)
	s.corner_radius_top_left = 30
	s.corner_radius_top_right = 30
	s.corner_radius_bottom_left = 30
	s.corner_radius_bottom_right = 30
	s.border_width_left = 2
	s.border_width_right = 2
	s.border_width_top = 2
	s.border_width_bottom = 2
	s.border_color = Color(0.4, 0.3, 0.2)
	return s

func create_secondary_hover() -> StyleBoxFlat:
	var s = create_secondary_normal()
	s.bg_color = Color(0.9, 0.88, 0.84)
	return s

func create_secondary_pressed() -> StyleBoxFlat:
	var s = create_secondary_normal()
	s.bg_color = Color(0.85, 0.82, 0.78)
	return s

func create_icon_normal() -> StyleBoxFlat:
	var s = StyleBoxFlat.new()
	s.bg_color = Color(0.96, 0.94, 0.9)
	s.corner_radius_top_left = 24
	s.corner_radius_top_right = 24
	s.corner_radius_bottom_left = 24
	s.corner_radius_bottom_right = 24
	return s

func create_icon_hover() -> StyleBoxFlat:
	var s = create_icon_normal()
	s.bg_color = Color(1, 0.9, 0.8)
	return s

func create_icon_pressed() -> StyleBoxFlat:
	var s = create_icon_normal()
	s.bg_color = Color(0.85, 0.82, 0.78)
	return s
