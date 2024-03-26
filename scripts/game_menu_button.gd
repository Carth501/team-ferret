extends Control

signal selected

@export var hovered_texture : TextureRect
@export var default_texture : TextureRect
var hovered := false

func toggle_on():
	print(str(name, " opened"))
	hovered_texture.visible = true
	default_texture.visible = false
	hovered = true

func toggle_off():
	print(str(name, " closed"))
	hovered_texture.visible = false
	default_texture.visible = true
	hovered = false

func choose(_viewport, event : InputEvent, _shape):
	if(hovered && event is InputEventMouseButton && event.is_action_released("click")):
		selected.emit()
