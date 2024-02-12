class_name module_manager extends Node

@onready var module_obj_dic := Dictionary()
@onready var module_id_list : Array[String] = []

func get_module_obj(id: String) -> abstract_module:
	if(!module_obj_dic.has(id)):
		return null
	return module_obj_dic[id]

func clear():
	module_obj_dic.clear()

func create_module_with_id(id : String) -> abstract_module:
	if(module_obj_dic.has(id)):
		return null
	var module_definition = dereferencer_single.module_by_id(id)
	var new_module
	match module_definition.type:
		"button":
			new_module = create_button()
		"switch":
			new_module = create_switch()
		_:
			push_error(str(module_definition.type, " not found. Check spelling."))
	configure_module(new_module, module_definition)
	check_for_error_side_effects(module_definition)
	return new_module

func check_for_error_side_effects(def : Variant):
	if(def.has("side_effects")):
		if(def.side_effects.has("cause_errors")):
			for new_error_id in def.side_effects.cause_errors:
				var new_error = dereferencer_single.error_by_id(new_error_id)
				for step in new_error.pattern:
					create_module_with_id(step.id)

func create_button() -> abstract_module:
	var button_scene = load("res://scenes/modules/button.tscn")
	return button_scene.instantiate() as button_module

func create_switch() -> abstract_module:
	var switch_scene = load("res://scenes/modules/switch.tscn")
	return switch_scene.instantiate() as switch_module

func configure_module(new_module: abstract_module, params):
	if(new_module == null):
		push_error("switch instance does not have the script attached")
	new_module.name = params.id
	new_module.set_control_def(params)
	new_module.set_label(str("[center]", params.label, "[/center]"))
	new_module.set_anchors_preset(Control.PRESET_CENTER, false)
	module_obj_dic[params.id] = new_module
