class_name data_libraries extends Node

var control_data
var error_data
var level_data
@export var control_definition_json = "res://data/control_list.json"
@export var error_definition_json = "res://data/error_list.json"
@export var level_definition_json = "res://data/level_list.json"

func _ready():
	control_data = load_json_file(control_definition_json)
	error_data = load_json_file(error_definition_json)
	level_data = load_json_file(level_definition_json)

func load_json_file(filePath: String):
	if FileAccess.file_exists(filePath):
		var dataFile = FileAccess.open(filePath, FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		
		if parsedResult is Array:
			return parsedResult
		else:
			push_error("error reading the control library")
	else:
		push_error("control library does not exist")

func dereference_error_id(id: String):
	for error_def in error_data.duplicate(true):
		if(error_def.id == id):
			return error_def
	push_error(str("did not find error def for id ", id))
