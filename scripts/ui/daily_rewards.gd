extends Control
class_name DailyRewards
## Daily rewards panel - 5 day cycle with water drop rewards

signal claim_pressed(day: int)

const REWARDS: Array[int] = [10, 15, 20, 30, 50]
const DAYS: int = 5

@onready var reward_slots: HBoxContainer = $VBox/RewardSlots
@onready var claim_button: Button = $VBox/GetButton

var current_day: int = 1
var can_claim: bool = true

func _ready() -> void:
	claim_button.pressed.connect(func(): AudioManager.sfx("click"); claim_pressed.emit(current_day))
	_update_display()

func set_day(day: int, claimable: bool = true) -> void:
	current_day = clamp(day, 1, DAYS)
	can_claim = claimable
	_update_display()

func _update_display() -> void:
	for i in range(DAYS):
		var slot = reward_slots.get_child(i) if i < reward_slots.get_child_count() else null
		if slot:
			var filled = i < current_day - 1
			var is_today = i == current_day - 1
			slot.set_filled(filled, is_today, REWARDS[i])
			if is_today:
				slot.set_claimable(can_claim)
