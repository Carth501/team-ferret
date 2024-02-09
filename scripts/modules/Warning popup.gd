class_name warning_popup extends Control

@export var warning_panel : Panel
@export var textbox : RichTextLabel

func toggle_panel(setting : bool):
	warning_panel.visible = setting

func show_panel():
	warning_panel.visible = true

func hide_panel():
	warning_panel.visible = false

func set_text(text : String):
	textbox.text = text
