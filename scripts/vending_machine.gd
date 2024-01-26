class_name Vending_Machine
extends Control

@onready var upgrades = $upgrades as Control
@onready var cost_disp = $cost_disp as Label
@onready var keypad = $keypad as Button
@onready var money_disp = $money_disp as Label
@onready var upgrade_popup = $UpgradePopup as Control


@export_category("Upgrades")
@export var _money := 10.00

var current_upgrade: Upgrade

func _ready():
	keypad.set_meta("cost", 0.0)
	keypad.set_meta("purchased", false)
	money_disp.text = str(_money)
	for upgrade in upgrades.get_children():
		if(upgrade.has_method("_on_upgrade_pressed")):
			var callable = Callable(self, "_on_DisplayUpgradeDetails")
			upgrade.connect("display_upgrade_details", callable)

func _on_DisplayUpgradeDetails(description, cost, purchased, node):
	print(str(node))
	current_upgrade = node
	print("Setting Description & Cost labels")
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
		money_disp.text = str(_money)
		keypad.disabled = true
		print("Upgrade purchased")
	elif(purchased):
		print("Upgrade already purchased")
	else:
		print("Not enough money")
	
	if(current_upgrade is Upgrade):
		print("Calling upgrade purchased signal")
		current_upgrade.emit_signal("upgrade_purchased")
