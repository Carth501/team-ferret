extends Control

@onready var upgrades = $upgrades as Control
@onready var upgrade_desc = $upgrade_desc as RichTextLabel
@onready var cost_disp = $cost_disp as Label
@onready var keypad = $keypad as Button

@export_category("Upgrades")
@export var _money := 10.00

var callable = Callable(self, "_on_DisplayUpgradeDetails")
var keypad_callable = Callable(self, "_on_keypad_pressed")

func _ready():
	for upgrade in upgrades.get_children():
		if(upgrade.has_method("_on_upgrade_pressed")):
			upgrade.connect("display_upgrade_details", callable)

	keypad.connect("pressed", keypad_callable)

func _on_DisplayUpgradeDetails(description, cost):
	upgrade_desc.text = description
	cost_disp = cost
	keypad.set_meta("cost", cost) # For use when purchasing an upgrade

func _on_keypad_pressed():
	var cost = keypad.get_meta("cost")
	if(_money >= cost):
		_money -= cost
		print("Upgrade purchased")
	else:
		print("Not enough money")
