class_name manual extends Control

@export var popup: Panel
@export var text: RichTextLabel
var pages: Array[String] = []
var page_index = 0

func toggle_manual_popup():
	popup.visible = !popup.visible
	write_page()

func build_error_list(error_list, control_list):
	var index = 0
	for error in error_list:
		pages.append(str("[b]", error.name, "[/b]"))
		var step_number = 1
		for step in error.pattern:
			var step_definition = dereference_module_id(control_list, step.id)
			if(!step.has("value")):
				pages[index] += str("\n", step_number, ". ", step_definition.label)
			else:
				pages[index] += str("\n", step_number, ". ", 
				step_definition.label, " set to [color=green]", step.value, "[/color]")
			step_number += 1
		index += 1

func dereference_module_id(control_list, id: String):
	for module_def in control_list:
		if(module_def.id == id):
			return module_def
	push_error(str("Manual did not find error def for id ", id))

func write_page():
	text.clear()
	text.append_text(pages[page_index])

func next_page():
	if(pages.size() > page_index + 1):
		page_index += 1
		write_page()
