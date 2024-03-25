extends Control

signal selected

@export var hovered_texture : TextureRect
@export var default_texture : TextureRect
var hovered := false

func toggle_on():
	hovered_texture.visible = true
	default_texture.visible = false
	hovered = true

func toggle_off():
	hovered_texture.visible = false
	default_texture.visible = true
	hovered = false

func choose(_viewport, event : InputEvent, _shape):
	if(event.is_action_just_released("click")):
		selected.emit()
