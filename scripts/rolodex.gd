class_name rolodex
extends Control

@onready var rolodex_anim = $rolodex_anim as AnimatedSprite2D
@onready var top_buttons = $top_buttons.get_children()
@onready var bot_buttons = $bot_buttons.get_children()
@onready var data := data_libraries_single
@onready var save_handler := save_handler_single
@export var check_marks: Array[Control]
@onready var level_buttons := [
	$level_links/Control/Button,
	$level_links/Control2/Button,
	$level_links/Control3/Button,
	$level_links/Control4/Button,
	$level_links/Control5/Button,
] 
var unlocked = true

@export_range(5, 30, 5) var current_page = 5
var anim_frame = 0

signal page_changed(current_page)
signal level_choice(level_id)

func _ready():
	rolodex_setup(current_page)
	write_level_links()

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

func write_level_links():
	if(!data.ready):
		await data.ready
	var level_data = data.level_data
	var complete_level_list: Array = save_handler.active_save.complete_levels
	var start: int = current_page - 5
	var level_index := find_start_index(start)
	var button_index = 0
	while level_index < current_page:
		print(str("level_index: ", level_index, " | current_page: ", current_page))
		var level = level_data[level_index]
		var metadata = level.metadata
		var secret_level = metadata.has("hidden") && metadata.hidden
		if(!secret_level):
			if(complete_level_list.has(metadata.id)):
				unlocked = true
				check_marks[level_index % 5].visible = true
			if(unlocked):
				print(str("level_buttons[button_index] ", level_buttons[button_index]))
				write_button(metadata, level_buttons[button_index])
				button_index += 1
				
				if(!complete_level_list.has(metadata.id)):
					check_marks[level_index % 5].visible = false
					unlocked = false
			else:
				check_marks[level_index % 5].visible = false
				level_buttons[level_index % 5].visible = false
		level_index += 1

func write_button(metadata, level_button: generic_button):
	level_button.name = metadata.name + " button"
	level_button.set_string(metadata.id)
	level_button.set_label(metadata.name)
	level_button.button_press.connect(select_level)

func find_start_index(start: int) -> int:
	var level_data = data.level_data
	var level_index := 0
	var r := 0
	while(r > start):
		level_index += 1
		var level = level_data[level_index]
		var metadata = level.metadata
		var secret_level = metadata.has("hidden") && metadata.hidden
		if(!secret_level):
			r += 1
	return level_index

func select_level(id: String):
	level_loader_single.load_level(id)

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
