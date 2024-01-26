class_name Upgrade
extends Button

@onready var upgrade = self as Button
@onready var purchased := false

@export_category("Upgrade")
@export_multiline var description := "Enter some details"
@export var cost := 1.00
@export var upgrade_id := "Unique Identifier"
@export var check_mark: Node

var callable = Callable(self, "_on_UpgradePurchased")

signal display_upgrade_details(cost, id)
signal upgrade_purchased

func _ready() -> void:
	self.connect("upgrade_purchased", callable)

func _on_upgrade_pressed():
	display_upgrade_details.emit(description, cost, purchased, self)
	print(str("_on_upgrade_pressed", description, " ", cost))

func _on_UpgradePurchased():
	print("upgrade_purchased signal received")
	purchased = true

func set_purchased(bought: bool):
	check_mark.visible = bought
	purchased = bought
