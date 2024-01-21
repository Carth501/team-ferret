extends Control

@export var percent_label: Label

func update_label(value: float):
	percent_label.text = "%3d" % value + "%"
