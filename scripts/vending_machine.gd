class_name Vending_Machine
extends Control

@onready var upgrades = $upgrades as Control
@onready var cost_disp = $cost_disp as Label
@onready var keypad = $keypad as Button
@onready var money_disp = $money_disp as Label
@onready var upgrade_popup = $UpgradePopup as Control
@onready var keypad_beep = $sfx/keypad_beep as AudioStreamPlayer
@onready var keypad_mech_beep = $sfx/keypad_mech_beep as AudioStreamPlayer
@onready var coin_insert = $sfx/coin_insert as AudioStreamPlayer
@onready var vend_w_return = $sfx/vend_wReturn as AudioStreamPlayer

@export_category("Upgrades")
var _money := 10.00
var purchased_upgrades: Dictionary
var plays = 0
var current_upgrade: Upgrade

func _ready():
	keypad.set_meta("cost", 0.0)
	keypad.set_meta("purchased", false)
	set_upgrades()
	for upgrade in upgrades.get_children():
		if(upgrade.has_method("_on_upgrade_pressed")):
			var callable = Callable(self, "_on_DisplayUpgradeDetails")
			upgrade.connect("display_upgrade_details", callable)
			var id = upgrade.upgrade_id
			upgrade.set_purchased(purchased_upgrades.has(id) && purchased_upgrades[id])
	_money = save_handler_single.active_save.money
	update_money()

func _on_DisplayUpgradeDetails(description, cost, purchased: bool, node):
	current_upgrade = node
	upgrade_popup.visible = true
	upgrade_popup.description_label.text = description
	cost_disp.text = str(cost)
	keypad.set_meta("cost", cost)
	keypad.set_meta("purchased", purchased)
	keypad.disabled = purchased

func _on_keypad_pressed():
	if(current_upgrade != null):
		var cost: float = keypad.get_meta("cost")
		var purchased: bool = keypad.get_meta("purchased")
		if(!purchased && _money >= cost):
			play_purchased()
			_money -= cost
			update_money()
			keypad.disabled = true
			save_handler_single.buy_upgrade(current_upgrade.upgrade_id, current_upgrade.cost)
			current_upgrade.set_purchased(true)
		else:
			keypad_beep.play()

		if(current_upgrade is Upgrade):
			current_upgrade.emit_signal("upgrade_purchased")

func set_upgrades():
	purchased_upgrades = save_handler_single.active_save.upgrades

func update_money():
	money_disp.text = str("$%.2f" % _money)

func play_purchased() -> void:
	coin_insert.play()

func _on_keypad_beep_finished():
	#var timer = Timer.new()
	#timer.wait_time = 1
	if(plays <= 2):
		print(str("Keypad plays: ", plays))
		plays += 1
		#timer.timeout.connect(keypad_beep.play)
		#timer.one_shot = true
		#timer.start()
		keypad_beep.play()
	else:
		vend_w_return.play()
		plays = 0

func _on_keypad_mech_beep_finished():
	pass # Replace with function body.

func _on_coin_insert_finished():
	keypad_beep.play()

func _on_vend_w_return_finished():
	pass # Replace with function body.
