class_name level_select extends Panel

@export var button_container: VBoxContainer
var data: data_libraries_single

func _ready():
	data = get_node("/root/data_libraries_single")
	if(!data.ready):
		await data.ready
	var level_data = data.level_data
	for level in level_data:
		var level_button = generic_button.new()
		button_container.add_child(level_button)
		
		# Accessing nested data
		var metadata = level.metadata
		var gameplay = level.gameplay
		
		level_button.set_string(metadata.id)
		level_button.set_label(metadata.name)
		level_button.button_press.connect(select_level)
		if(metadata.has("hidden") && metadata.hidden):
			level_button.visible = false
		
func select_level(id: String):
	var loader = get_node("/root/level_loader_single")
	if(!loader.ready):
		await loader.ready
	loader.load_level(id)
