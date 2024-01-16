class_name manual extends Control

@export var popup: PopupPanel
@export var text: Label

func toggle_manual_popup():
	popup.visible = !popup.visible

func build_error_list(error_list):
	for error in error_list:
		text.text += (str(error))
