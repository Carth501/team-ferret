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
