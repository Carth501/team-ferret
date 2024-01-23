class_name manual
extends Control

@onready var manual_book = $manual_book as Node2D
@export var popup: Panel
@export var text: RichTextLabel

var pages: Array = []
var pages_index: Array[String] = []
var page_index = 0
var index_page_size = 20

var l_header
var l_body
var r_header
var r_body

func _ready():
	l_header = manual_book.left_header
	l_body = manual_book.left_text
	r_header = manual_book.right_header
	r_body = manual_book.right_text
	

func toggle_manual_popup():
	#popup.visible = !popup.visible
	manual_book.visible = !manual_book.visible
	write_page()

func write_manual(error_list, control_list):
	build_index(error_list)
	build_error_list(error_list, control_list)

func build_index(error_list):
	var index_length := ceili(error_list.size() / 30.0)
	var count := 0
	var index_page := 0
	pages_index.append("")
	for error in error_list:
		if(count >= index_page_size):
			count = 0
			index_page += 1
			pages_index.append("")
		var page_link = 1 + index_length + count + index_page * index_page_size
		var index_entry := str("[url={\"page\":", page_link, "}]", error.hex, "\t ", error.name,"[/url]")
		pages_index[index_page] += index_entry + "\n"
		count += 1

func build_error_list(error_list, control_list):
	var page_number = 1
	var sw_text
	for error in error_list:
		var page = {
			"title": str(page_number, ". ", error.hex, " : ", error.name),
			"body": "",
			"error_hex": error.hex,
			"page_number": page_number
		}
		
		var step_number = 1
		for step in error.pattern:
			var step_definition = dereference_module_id(control_list, step.id)
			var line_text = str("\n", step_number, ". ", step_definition.label)
			if(step.has("value")):
				if(step_definition.label != "Fight for the users"):
					sw_text = "On" if step.value else "Off"
				var txt_color = "[color=darkgreen]" if step.value else "[color=darkred]"
				line_text = str(line_text, " set to ", txt_color, sw_text, "[/color]")
			
			page["body"] += line_text
			step_number +=1
			
		pages.append(page)
		page_number += 1
		
	return pages

func dereference_module_id(control_list, id: String):
	for module_def in control_list:
		if(module_def.id == id):
			return module_def
	push_error(str("Manual did not find error def for id ", id))

func write_page():
	l_header.text = ""
	l_body.clear()
	r_header.text = ""
	r_body.clear()

	if pages.size() > page_index:
		var currentPage = pages[page_index]
		l_header.text = currentPage["title"]
		l_body.text = currentPage["body"]
		
		if(currentPage["title"] == ""):
			l_header.text = str("END OF LINE.")

		if pages.size() > page_index + 1:
			var nextPage = pages[page_index + 1]
			r_header.text = nextPage["title"]
			r_body.text = nextPage["body"]

func prev_page():
	if page_index > 1:
		page_index -= 2
		write_page()
	else:
		page_index = 0
	

func next_page():
	if pages.size() > page_index + 1:
		page_index += 2
		write_page()

func parse_hyperlink(meta: Variant):
	var parsedResult = JSON.parse_string(meta)
	if(parsedResult.has("page")):
		jump_to_page(parsedResult.page)

func jump_to_page(index: int):
	page_index = index
	write_page()
	







