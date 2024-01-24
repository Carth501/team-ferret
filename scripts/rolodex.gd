class_name rolodex
extends Control

@onready var rolodex_anim = $rolodex_anim as AnimatedSprite2D
@onready var top_buttons = $top_buttons.get_children()
@onready var bot_buttons = $bot_buttons.get_children()

@export_range(5, 30, 5) var current_page = 5
var anim_frame = 0

signal page_changed(current_page)

func _ready():
	rolodex_setup(current_page)

func rolodex_setup(page) -> void:
	if(page < 5 or page > 30 or page % 5 != 0):
		push_error("Invalid page number: ", str(page), ", sent to rolodex_setup")
		return
	
	anim_frame = page / 5 - 1
	rolodex_anim.frame = anim_frame

	for button in top_buttons:
		var button_value = int(button.name.split("_")[0])
		button.visible = page <= button_value
	
	for button in bot_buttons:
		var button_value = int(button.name.split("_")[0])
		button.visible = page > button_value
	
	emit_signal("page_changed", page)


func _on_5_top_pressed():
	current_page = 5
	rolodex_setup(current_page)

func _on_10_top_pressed():
	current_page = 10
	rolodex_setup(current_page)

func _on_15_top_pressed():
	current_page = 15
	rolodex_setup(current_page)

func _on_20_top_pressed():
	current_page = 20
	rolodex_setup(current_page)

func _on_25_top_pressed():
	current_page = 25
	rolodex_setup(current_page)

func _on_30_top_pressed():
	current_page = 30
	rolodex_setup(current_page)

func _on_5_bot_pressed():
	current_page = 5
	rolodex_setup(current_page)

func _on_10_bot_pressed():
	current_page = 10
	rolodex_setup(current_page)

func _on_15_bot_pressed():
	current_page = 15
	rolodex_setup(current_page)

func _on_20_bot_pressed():
	current_page = 20
	rolodex_setup(current_page)

func _on_25_bot_pressed():
	current_page = 25
	rolodex_setup(current_page)
