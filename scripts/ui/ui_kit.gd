extends Resource
class_name UIKit

# Bloom UI Kit - Color Palette and Theme Constants
# Based on ui-kit.png and GDD

# Colors from GDD
const C_BG: Color = Color("F5F0E6")  # Cream/Beige background
const C_PRIMARY: Color = Color("7CB87C")  # Soft Green
const C_STAR: Color = Color("FFD93D")  # Gold stars
const C_SUCCESS: Color = Color("4CAF50")  # Bright Green
const C_FAILURE: Color = Color("E57373")  # Soft Red
const C_TEXT_PRIMARY: Color = Color("4A3728")  # Dark Brown
const C_TEXT_SECONDARY: Color = Color("8B7355")  # Warm Gray
const C_ACCENT: Color = Color("FF8A80")  # Coral Pink

# Additional UI Kit colors
const C_AMBER: Color = Color("FFB74D")  # Amber/Orange for primary buttons
const C_WOOD_DARK: Color = Color("5D4037")  # Dark wood
const C_WOOD_LIGHT: Color = Color("8D6E63")  # Light wood
const C_WATER: Color = Color("64B5F6")  # Blue for currency
const C_PARCHMENT: Color = Color("FFF8E7")  # Light parchment

# Typography sizes
const SIZE_TITLE: int = 48
const SIZE_HEADING: int = 32
const SIZE_BUTTON: int = 18
const SIZE_BODY: int = 16
const SIZE_CAPTION: int = 14
const SIZE_SMALL: int = 12

# Spacing
const SPACE_XS: int = 4
const SPACE_SM: int = 8
const SPACE_MD: int = 16
const SPACE_LG: int = 24
const SPACE_XL: int = 32

# Corner radius
const RADIUS_SM: float = 8.0
const RADIUS_MD: float = 16.0
const RADIUS_LG: float = 24.0
const RADIUS_PILL: float = 100.0

# Button styles
static func make_primary_button_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = C_AMBER
	style.corner_radius_top_left = RADIUS_PILL
	style.corner_radius_top_right = RADIUS_PILL
	style.corner_radius_bottom_left = RADIUS_PILL
	style.corner_radius_bottom_right = RADIUS_PILL
	style.set_content_margin_all(SPACE_MD)
	style.shadow_color = Color(0, 0, 0, 0.2)
	style.shadow_size = 4
	return style

static func make_secondary_button_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = C_WOOD_DARK
	style.corner_radius_top_left = RADIUS_MD
	style.corner_radius_top_right = RADIUS_MD
	style.corner_radius_bottom_left = RADIUS_MD
	style.corner_radius_bottom_right = RADIUS_MD
	style.set_content_margin_all(SPACE_MD)
	style.shadow_color = Color(0, 0, 0, 0.2)
	style.shadow_size = 3
	return style

static func make_success_button_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = C_SUCCESS
	style.corner_radius_top_left = RADIUS_MD
	style.corner_radius_top_right = RADIUS_MD
	style.corner_radius_bottom_left = RADIUS_MD
	style.corner_radius_bottom_right = RADIUS_MD
	style.set_content_margin_all(SPACE_MD)
	style.shadow_color = Color(0, 0, 0, 0.2)
	style.shadow_size = 3
	return style

static func make_card_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = C_PARCHMENT
	style.corner_radius_top_left = RADIUS_LG
	style.corner_radius_top_right = RADIUS_LG
	style.corner_radius_bottom_left = RADIUS_LG
	style.corner_radius_bottom_right = RADIUS_LG
	style.set_content_margin_all(SPACE_MD)
	style.shadow_color = Color(0, 0, 0, 0.15)
	style.shadow_size = 6
	return style

static func make_modal_overlay_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0, 0, 0, 0.5)
	return style

static func make_header_bar_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = C_WOOD_DARK
	style.set_content_margin_all(SPACE_MD)
	return style

static func make_grid_cell_style(terrain: int = 0) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.corner_radius_top_left = RADIUS_SM
	style.corner_radius_top_right = RADIUS_SM
	style.corner_radius_bottom_left = RADIUS_SM
	style.corner_radius_bottom_right = RADIUS_SM
	style.set_content_margin_all(2)
	
	match terrain:
		0:  # Grass
			style.bg_color = Color("A5D6A7")  # Soft green
		1:  # Water
			style.bg_color = Color("81D4FA")  # Light blue
		2:  # Rock
			style.bg_color = Color("9E9E9E")  # Gray
		3:  # Weed
			style.bg_color = Color("AED581")  # Yellowish green
		4:  # Void
			style.bg_color = Color("424242", 0.5)  # Dark gray transparent
		_:
			style.bg_color = Color("C8E6C9")  # Default grass
	
	return style

# Star display helpers
static func make_star_filled() -> String:
	return "⭐"

static func make_star_empty() -> String:
	return "☆"

static func format_stars(count: int, max_count: int = 3) -> String:
	var stars := ""
	for i in range(max_count):
		if i < count:
			stars += make_star_filled()
		else:
			stars += make_star_empty()
	return stars
