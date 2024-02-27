class_name manual_book_scene
extends Control

@onready var left_header = $TextureRect/MarginContainer/HBoxContainer/left_page/left_header as Label
@onready var left_text = $TextureRect/MarginContainer/HBoxContainer/left_page/left_text as RichTextLabel
@onready var right_header = $TextureRect/MarginContainer/HBoxContainer/right_page/right_header as Label
@onready var right_text = $TextureRect/MarginContainer/HBoxContainer/right_page/right_text as RichTextLabel

@export_category("book_settings")
@export var book_margin := 100.0

signal next_page
signal prev_page
signal to_index
signal to_page(number: int)
signal close
var drag_offset: Vector2
var initial_position: Vector2
var mouse_over: bool = false
var holding: bool = false
var in_window: bool = true

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

func close_manual():
	close.emit()

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
			var new_position = initial_position + delta_position
			#position = initial_position + delta_position 
			var viewport_size = get_viewport_rect().size
			var margin = Vector2(book_margin, book_margin)
			var max_x = viewport_size.x - margin.x
			var max_y = viewport_size.y - margin.y
			new_position.x = clamp(new_position.x, 0, max_x)
			new_position.y = clamp(new_position.y, 0, max_y)
			position = new_position


func _notification(what):
	if what == NOTIFICATION_WM_MOUSE_ENTER:
		in_window = true
	elif what == NOTIFICATION_WM_MOUSE_EXIT:
		in_window = false

func _on_mouse_entered():
	mouse_over = true

func _on_mouse_exited():
	mouse_over = false
