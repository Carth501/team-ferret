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
	print(save_data)

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
		print(str("no file found @ ", path))
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
		print(str("no file found @ ", path, ". Creating a new save file."))

	var save_game = FileAccess.open(path, FileAccess.WRITE)
	var stringified_data = JSON.stringify(data)
	save_game.store_line(stringified_data)


func create_new_save() -> Variant:
	var date_string = Time.get_date_string_from_system(true)
	var data = {
		"name": str(date_string),
		"datetime": str(Time.get_datetime_string_from_system(true))
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
	var tree = get_tree()
	var error = tree.change_scene_to_file("res://scenes/game_menu.tscn")
	
