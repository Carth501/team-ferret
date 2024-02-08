class_name pager_light extends ColorRect

@onready var on_light := $On

func toggle(setting : bool):
	print(str(name, " toggle ", setting))
	on_light.visible = setting
