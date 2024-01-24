class_name level_select extends Panel

@export var button_container: VBoxContainer
@onready var data := data_libraries_single
@onready var save_handler := save_handler_single
var unlocked = true

func _ready():
	if(!data.ready):
		await data.ready
	var level_data = data.level_data
	var complete_level_list: Array = save_handler.active_save.complete_levels
	var check_scene = load("res://scenes/check_mark.tscn")
	for level in level_data:
		var metadata = level.metadata
		if(complete_level_list.has(metadata.id)):
			unlocked = true
		if(unlocked):
			var level_row = Control.new()
			button_container.add_child(level_row)
			level_row.name = metadata.name + " row"
			var level_button = generic_button.new()
			level_row.add_child(level_button)
			level_button.name = metadata.name + " button"
			level_button.position = Vector2(30,0)
			
			# Accessing nested data
			
			level_button.set_string(metadata.id)
			level_button.set_label(metadata.name)
			level_button.button_press.connect(select_level)
			if(complete_level_list != null && complete_level_list.size() > 0):
				if(complete_level_list.has(metadata.id)):
					var instance = check_scene.instantiate()
					level_row.add_child(instance)
			var secret_level = metadata.has("hidden") && metadata.hidden
			if(secret_level):
				level_row.visible = false
			if(!secret_level && !complete_level_list.has(metadata.id)):
				unlocked = false

func select_level(id: String):
	var loader = get_node("/root/level_loader_single")
	if(!loader.ready):
		await loader.ready
	loader.load_level(id)
