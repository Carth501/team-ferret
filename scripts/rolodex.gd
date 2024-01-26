class_name rolodex
extends Control

@onready var turn_player = $turnPlayer as AudioStreamPlayer
@onready var rolodex_anim = $rolodex_anim as AnimatedSprite2D
@onready var top_buttons = $top_buttons.get_children()
@onready var bot_buttons = $bot_buttons.get_children()
@onready var data := data_libraries_single
@onready var save_handler := save_handler_single
@onready var check_marks := [
	$level_links/Control/CheckMark,
	$level_links/Control2/CheckMark,
	$level_links/Control3/CheckMark,
	$level_links/Control4/CheckMark,
	$level_links/Control5/CheckMark,
] 
@onready var level_buttons := [
	$level_links/Control/Button,
	$level_links/Control2/Button,
	$level_links/Control3/Button,
	$level_links/Control4/Button,
	$level_links/Control5/Button,
] 
var level_data: Array[Variant]

@export_range(5, 30, 5) var current_page = 5
var anim_frame = 0

signal page_changed(current_page)
signal level_choice(level_id)

func _ready():
	level_data = await filter_levels()
	connect_buttons()
	flip_page(current_page)

func filter_levels() -> Array[Variant]:
	if(!data.ready):
		await data.ready
	var levels_from_file = data.level_data
	var result : Array[Variant] = []
	for level in levels_from_file:
		if(!level.metadata.has("hidden") || !level.metadata.hidden):
			result.append(level)
	return result

func connect_buttons():
	for button in level_buttons:
		button.button_press.connect(select_level)

func rolodex_setup(page) -> void:
	if(current_page == page):
		return
	else:
		turn_player.play()
		flip_page(page)

func flip_page(page):
	if(page < 5 or page > 30 or page % 5 != 0):
		push_error("Invalid page number: ", str(page), ", sent to rolodex_setup")
		return
	
	current_page = page
	anim_frame = page / 5 - 1
	rolodex_anim.frame = anim_frame

	for button in top_buttons:
		var button_value = int(button.name.split("_")[0])
		button.visible = page <= button_value
	
	for button in bot_buttons:
		var button_value = int(button.name.split("_")[0])
		button.visible = page > button_value
	
	emit_signal("page_changed", page)
	write_level_links()

func write_level_links():
	var complete_level_list:Array = save_handler.active_save.complete_levels
	var start: int = current_page - 5
	if(start > level_data.size()):
		hide_all()
		return
	var button_index = 0
	while button_index < 5:
		if(start + button_index < level_data.size()):
			var level = level_data[start + button_index]
			var metadata = level.metadata
			if(complete_level_list.has(metadata.id)):
				check_marks[button_index].visible = true
			if(check_unlocked(start + button_index, complete_level_list)):
				level_buttons[button_index].visible = true
				write_button(metadata, level_buttons[button_index])
				
				if(!complete_level_list.has(metadata.id)):
					check_marks[button_index].visible = false
			else:
				hide_line(button_index)
		else:
			hide_line(button_index)
		button_index += 1

func check_unlocked(level_index: int, complete_level_list: Array) -> bool:
	var complete = complete_level_list.has(level_data[level_index].metadata.id)
	var unlocked = complete_level_list.has(level_data[level_index - 1].metadata.id)
	return complete || unlocked || level_index == 0

func hide_all():
	var button_index = 0
	while button_index < 5:
		hide_line(button_index)
		button_index += 1

func hide_line(button_index: int):
	check_marks[button_index].visible = false
	level_buttons[button_index].visible = false

func write_button(metadata, level_button: generic_button):
	level_button.name = metadata.name + " button"
	level_button.set_string(metadata.id)
	level_button.set_label(metadata.name)

func select_level(id: String):
	level_loader_single.load_level(id)

func _on_5_top_pressed():
	rolodex_setup(5)

func _on_10_top_pressed():
	rolodex_setup(10)

func _on_15_top_pressed():
	rolodex_setup(15)

func _on_20_top_pressed():
	rolodex_setup(20)

func _on_25_top_pressed():
	rolodex_setup(25)

func _on_30_top_pressed():
	rolodex_setup(30)

func _on_5_bot_pressed():
	rolodex_setup(5)

func _on_10_bot_pressed():
	rolodex_setup(10)

func _on_15_bot_pressed():
	rolodex_setup(15)

func _on_20_bot_pressed():
	rolodex_setup(20)

func _on_25_bot_pressed():
	rolodex_setup(25)
