extends Control
class_name StoreScreen
## Store screen with IAP options and currency display

signal home_pressed
signal levels_pressed
signal settings_pressed
signal purchase_completed(amount: int)
signal restore_pressed

const PACKAGES: Array = [
	{"id": "drops_100", "drops": 100, "price": 0.99},
	{"id": "drops_150", "drops": 150, "price": 1.49, "bonus": true},
	{"id": "drops_500", "drops": 500, "price": 4.99, "bonus": true},
	{"id": "drops_1000", "drops": 1000, "price": 9.99, "bonus": true},
]

@onready var currency_label: Label = $HeaderBar/CurrencyDisplay/CurrencyLabel
@onready var package_list: VBoxContainer = $ScrollContainer/PackageList
@onready var bottom_nav: Control = $BottomNav
@onready var restore_link: LinkButton = $Footer/RestoreLink

var current_drops: int = 0

func _ready() -> void:
	bottom_nav.home_pressed.connect(func(): AudioManager.sfx("click"); home_pressed.emit())
	bottom_nav.levels_pressed.connect(func(): AudioManager.sfx("click"); levels_pressed.emit())
	bottom_nav.settings_pressed.connect(func(): AudioManager.sfx("click"); settings_pressed.emit())
	restore_link.pressed.connect(func(): AudioManager.sfx("click"); restore_pressed.emit())
	_populate_packages()

func set_currency(amount: int) -> void:
	current_drops = amount
	currency_label.text = str(amount)

func _populate_packages() -> void:
	for pkg in PACKAGES:
		var row = _create_package_row(pkg)
		package_list.add_child(row)

func _create_package_row(pkg: Dictionary) -> HBoxContainer:
	var row = HBoxContainer.new()
	row.add_child(_create_drops_display(pkg["drops"]))
	row.add_child(_create_bonus_badge() if pkg.get("bonus") else Control.new())
	row.add_child(_create_price_button(pkg))
	return row

func _create_drops_display(drops: int) -> HBoxContainer:
	var hbox = HBoxContainer.new()
	var icon = TextureRect.new()
	# TODO: water drop icon
	var label = Label.new()
	label.text = "+%d" % drops
	hbox.add_child(icon)
	hbox.add_child(label)
	return hbox

func _create_bonus_badge() -> TextureRect:
	var badge = TextureRect.new()
	badge.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	return badge

func _create_price_button(pkg: Dictionary) -> Button:
	var btn = Button.new()
	btn.text = "$%.2f" % pkg["price"] if pkg.get("price") else "Proceed"
	btn.pressed.connect(func(): _on_package_selected(pkg))
	return btn

func _on_package_selected(pkg: Dictionary) -> void:
	# IAP integration point
	purchase_completed.emit(pkg["drops"])
