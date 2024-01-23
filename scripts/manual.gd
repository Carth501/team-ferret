class_name manual extends Control

@export var popup: Panel
@export var text: RichTextLabel
var pages: Array[String] = []
var page_index = 0
var index_page_size = 20

func toggle_manual_popup():
	popup.visible = !popup.visible
	write_page()

func write_manual(error_list, control_list):
	build_index(error_list)
	build_error_list(error_list, control_list)

func build_index(error_list):
	var index_length := ceili(error_list.size() / 30.0)
	var count := 0
	var index_page := 0
	pages.append("")
	for error in error_list:
		if(count >= index_page_size):
			count = 0
			index_page += 1
			pages.append("")
		var page_link = 1 + index_length + count + index_page * index_page_size
		var index_entry := str("[url={\"page\":", page_link, "}]", error.hex, "\t ", error.name,"[/url]")
		pages[index_page] += index_entry + "\n"
		count += 1

func build_error_list(error_list, control_list):
	var index = pages.size()
	for error in error_list:
		pages.append(str("[b]",error.hex, " : ", error.name, "[/b]"))
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

func prev_page():
	if(page_index > 0):
		page_index -= 1
		write_page()

func parse_hyperlink(meta: Variant):
	var parsedResult = JSON.parse_string(meta)
	if(parsedResult.has("page")):
		jump_to_page(parsedResult.page)

func jump_to_page(index: int):
	page_index = index
	write_page()
