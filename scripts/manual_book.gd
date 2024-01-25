class_name manual_book_scene
extends Node2D

@onready var left_header = $TextureRect/MarginContainer/HBoxContainer/left_page/left_header as Label
@onready var left_text = $TextureRect/MarginContainer/HBoxContainer/left_page/left_text as RichTextLabel
@onready var right_header = $TextureRect/MarginContainer/HBoxContainer/right_page/right_header as Label
@onready var right_text = $TextureRect/MarginContainer/HBoxContainer/right_page/right_text as RichTextLabel

signal next_page
signal prev_page
signal to_index
signal to_page(number: int)

var drag_offset: Vector2
var initial_position: Vector2
var mouse_over: bool = false
var holding: bool = false
var in_window: bool = true

func _on_gui_input(event):
	if(event is InputEventMouseButton):
		if(event.is_pressed() && mouse_over):
			drag_offset = get_viewport().get_mouse_position()
			initial_position = position
			holding = true
		else:
			holding = false
	elif(event is InputEventMouseMotion):
		if(holding && in_window):
			var delta_position = get_viewport().get_mouse_position() - drag_offset
			position = initial_position + delta_position 

func _notification(what):
	if what == NOTIFICATION_WM_MOUSE_ENTER:
		in_window = true
	elif what == NOTIFICATION_WM_MOUSE_EXIT:
		in_window = false

func _on_mouse_entered():
	mouse_over = true

func _on_mouse_exited():
	mouse_over = false

func prev_button():
	emit_signal("prev_page")

func next_button():
	emit_signal("next_page")
	
func index_shortcut():
	to_index.emit()

func parse_hyperlink(meta: Variant):
	var parsedResult = JSON.parse_string(meta)
	if(parsedResult.has("page")):
		to_page.emit(parsedResult.page)
