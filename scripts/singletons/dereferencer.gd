class_name dereferencer extends Node

func error_by_id(id: String):
	for error_def in data_libraries_single.error_data:
		if(error_def.id == id):
			return error_def.duplicate(true)
	push_error(str("did not find error def for id ", id))

func module_by_id(id: String):
	for module_def in data_libraries_single.control_data:
		if(module_def.id == id):
			return module_def.duplicate(true)
	push_error(str("did not find module def for id ", id))
