extends Control

@onready var description_label = $description_label as RichTextLabel
@onready var close_button = $close_button as Button

func show_description(description: String):
	description_label.text = description

func _on_close_button():
	self.visible = false
