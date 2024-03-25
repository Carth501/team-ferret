class_name game_menu extends Node

var active_save_file: Variant
@export var vending_control : Control
@export var rolodex_control : Control

func _ready():
	request_save()

func request_save():
	var save_handler = get_node("/root/save_handler_single")
	if(save_handler == null):
		push_error("save_handler singleton not found.")
	if(!save_handler.ready):
		await save_handler.ready
	active_save_file = save_handler.active_save

func load_continue():
	var loader = get_node("/root/level_loader_single")
	if(loader == null):
		push_error("loader singleton not found.")
	if(!loader.ready):
		await loader.ready
	loader.load_continue()

func jump_to_title():
	var save_handler = get_node("/root/save_handler_single")
	save_handler.shift_to_title()

func select_level(id: String):
	level_loader_single.load_level(id)

func open_vending():
	vending_control.visible = true

func close_vending():
	vending_control.visible = false
	
func open_rolodex():
	rolodex_control.visible = true

func close_rolodex():
	rolodex_control.visible = false
