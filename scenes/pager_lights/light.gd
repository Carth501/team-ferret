class_name pager_light extends ColorRect

@export var on_light : Control

func toggle(setting : bool):
	on_light.visible = setting
