extends Node

@export var save_path = "user://saves/"
@export var user_root_path = "user://"
@export var in_game_menu: game_menu
var save_data: Array[Variant]
var save_file_names: Array[String]
var active_save: Variant

func _ready():
	dir_contents()
	save_data = read_saves()

func read_saves() -> Array[Variant]:
	save_data = []
	for file_name in save_file_names:
		var save = read_save(file_name)
		if(save != null):
			save_data.append(save)
	return save_data

func read_save(file_name: String):
	var path = save_path + file_name
	if (!FileAccess.file_exists(path)):
		return

	var save_game = FileAccess.open(path, FileAccess.READ)
	var parsedResult = JSON.parse_string(save_game.get_as_text())
	if parsedResult is Variant:
		save_game.close()
		return parsedResult
	else:
		return


func write_save(data: Variant):
	var path = save_path + data.name + ".save"
	if (!FileAccess.file_exists(path)):
		push_warning(str("no file found @ ", path, ". Creating a new save file."))

	var save_game = FileAccess.open(path, FileAccess.WRITE)
	var stringified_data = JSON.stringify(data)
	save_game.store_line(stringified_data)


func create_new_save() -> Variant:
	var date_string = Time.get_date_string_from_system(true)
	var data = {
		"name": str(date_string),
		"datetime": str(Time.get_datetime_string_from_system(true)),
		"complete_levels": []
	}
	write_save(data)
	return data

func dir_contents():
	var dir = DirAccess.open(save_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		save_file_names = []
		while file_name != "":
			if dir.current_is_dir():
				break
			else:
				save_file_names.append(file_name)
			file_name = dir.get_next()
	else:
		dir = DirAccess.open(user_root_path)
		dir.make_dir_recursive(save_path)
		dir_contents()

func load_game(save: Variant):
	active_save = save
	shift_to_game_menu()

func shift_to_game_menu():
	transition_screen_single.transitioned.connect(go_to_game_menu)
	transition_screen_single.transition()

func shift_to_title():
	transition_screen_single.transitioned.connect(go_to_main_menu)
	transition_screen_single.transition()

func level_complete(level_id: String):
	if(!active_save.has("complete_levels")):
		active_save["complete_levels"] = []
	var complete_levels: Array = active_save["complete_levels"]
	if(!complete_levels.has(level_id)):
		complete_levels.append(level_id)
		write_save(active_save)
	print("load game")
	transition_screen_single.transitioned.connect(go_to_game_menu)
	transition_screen_single.transition()

func go_to_game_menu():
	change_to("res://scenes/game_menu.tscn")
	transition_screen_single.transitioned.disconnect(go_to_game_menu)

func go_to_main_menu():
	change_to("res://scenes/main_menu.tscn")
	transition_screen_single.transitioned.disconnect(go_to_main_menu)
	
func change_to(path: String):
	get_tree().change_scene_to_file(path)
