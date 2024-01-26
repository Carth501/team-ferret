class_name Vending_Machine
extends Control

@onready var upgrades = $upgrades as Control
@onready var cost_disp = $cost_disp as Label
@onready var keypad = $keypad as Button
@onready var money_disp = $money_disp as Label
@onready var upgrade_popup = $UpgradePopup as Control


@export_category("Upgrades")
var _money := 10.00
var purchased_upgrades: Dictionary

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
	var cost: float = keypad.get_meta("cost")
	var purchased: bool = keypad.get_meta("purchased")
	if(!purchased && _money >= cost):
		_money -= cost
		update_money()
		keypad.disabled = true
		save_handler_single.buy_upgrade(current_upgrade.upgrade_id, current_upgrade.cost)
	elif(purchased):
		print("Upgrade already purchased")
	else:
		print("Not enough money")
	
	if(current_upgrade is Upgrade):
		print("Calling upgrade purchased signal")
		current_upgrade.emit_signal("upgrade_purchased")

func set_upgrades():
	purchased_upgrades = save_handler_single.active_save.upgrades

func update_money():
	money_disp.text = str("$%.2f" % _money)
