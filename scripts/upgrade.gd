class_name upgrade
extends Button

@onready var upgrade = self as Button

@export_category("Upgrade")
@export_multiline var description := "Enter some details"
@export var cost := 1.00
@export var upgrade_id := "Unique Identifier"

var but_callable = Callable(self, "_on_upgrade_pressed")

signal display_upgrade_details(description, cost)

func _ready():
	self.connect("pressed", but_callable)

func _on_upgrade_pressed():
	display_upgrade_details.emit(description, cost)
	print(str("_on_upgrade_pressed", description, " ", cost))
