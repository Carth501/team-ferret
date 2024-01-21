class_name main_menu extends Node

@export var play_button: Button
@onready var options = $"MenuContainer/Button Control/options" as Button
@onready var options_menu = $options_menu as OptionsMenu
@onready var menu_container = $MenuContainer as MarginContainer



var save_data: Array[Variant]

func _ready():
	handle_connecting_signals()
	var save_handler = get_node("/root/save_handler_single")
	if(save_handler == null):
		push_error("save_handler singleton not found.")
	if(!save_handler.ready):
		await save_handler.ready
	save_data = save_handler.save_data
	if(save_data.size() == 0):
		play_button.text = "NEW GAME"
		play_button.pressed.disconnect(load_latest)
		play_button.pressed.connect(create_new_game)

func queue_load_save_data(data: Variant):
	save_handler_single.load_game(data)

func create_new_game():
	var data = save_handler_single.create_new_save()
	queue_load_save_data(data)

func load_latest():
	var latest = get_latest_save()
	queue_load_save_data(latest)
	
func on_options_pressed() -> void:
	menu_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true

func on_exit_options_menu() -> void:
	menu_container.visible = true
	options_menu.visible = false

func handle_connecting_signals() -> void:
	options.button_down.connect(on_options_pressed)
	options_menu.exit_options_menu.connect(on_exit_options_menu)

func get_latest_save() -> Variant:
	var data = save_handler_single.save_data
	if(data.size() == 0):
		push_error("data.size() == 0, but still trying to load latest")
	elif(data.size() == 1):
		return data[0]
	var latest_save = data[0]
	for save in data:
		if(save.datetime > latest_save.datetime):
			latest_save = save_data
	return latest_save
