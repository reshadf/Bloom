extends CanvasLayer

@onready var back_button: Button = $TopBar/BackButton
@onready var shop_vbox: VBoxContainer = $ScrollContainer/VBox

# Shop items defined by monetization policy (cosmetic ONLY)
const SHOP_ITEMS: Array = [
	{"category": "THEMES", "items": [
		{"id": "theme_meadow", "name": "Meadow Theme", "desc": "Soft greens and warm whites", "price": 0.0, "owned": true},
		{"id": "theme_desert", "name": "Desert Theme", "desc": "Warm oranges and dusty pinks", "price": 1.99, "owned": false},
		{"id": "theme_ocean", "name": "Ocean Theme", "desc": "Blues and coral tones", "price": 1.99, "owned": false},
		{"id": "theme_space", "name": "Space Theme", "desc": "Deep purple with neon glows", "price": 2.49, "owned": false},
		{"id": "theme_winter", "name": "Winter Theme", "desc": "Ice blues and silver", "price": 2.49, "owned": false}
	]},
	{"category": "PLANT COLORS", "items": [
		{"id": "colors_default", "name": "Classic Colors", "desc": "Default flower palette", "price": 0.0, "owned": true},
		{"id": "colors_sunset", "name": "Sunset Pack", "desc": "Warm orange and pink", "price": 0.99, "owned": false},
		{"id": "colors_forest", "name": "Forest Pack", "desc": "Deep greens and earth tones", "price": 0.99, "owned": false},
		{"id": "colors_royal", "name": "Royal Pack", "desc": "Purple and gold", "price": 0.99, "owned": false}
	]},
	{"category": "EFFECTS", "items": [
		{"id": "effect_sparkle", "name": "Sparkle Burst", "desc": "Glitter on level complete", "price": 0.49, "owned": false},
		{"id": "effect_butterflies", "name": "Butterflies", "desc": "Animated butterflies", "price": 0.99, "owned": false},
		{"id": "effect_fireflies", "name": "Fireflies", "desc": "Glowing firefly ambient", "price": 0.99, "owned": false}
	]},
	{"category": "NO ADS", "items": [
		{"id": "no_ads", "name": "Ad-Free Forever", "desc": "Remove all advertisements", "price": 2.99, "owned": false}
	]}
]

func _ready() -> void:
	back_button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/screens/main_menu.tscn"))
	populate_shop()

func populate_shop() -> void:
	var owned = SaveManager.save_data.get("unlocks", {})
	
	for category in SHOP_ITEMS:
		# Category header
		var header = Label.new()
		header.text = "— " + category.category + " —"
		header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		shop_vbox.add_child(header)
		
		for item in category.items:
			var btn = create_shop_item(item, owned)
			shop_vbox.add_child(btn)

func create_shop_item(item: Dictionary, owned: Dictionary) -> Button:
	var btn = Button.new()
	btn.custom_minimum_size = Vector2(0, 80)
	
	var price_text = "FREE" if item.price == 0.0 else "€%.2f" % item.price
	var status = "✓ OWNED" if owned.has(item.id) or item.owned else price_text
	
	btn.text = "%s\n%s — %s" % [item.name, item.desc, status]
	btn.text_overrun_behavior = TextServer.OVERRUN_TRUNCATE_WORD
	
	if owned.has(item.id) or item.owned:
		btn.disabled = true
	
	return btn
