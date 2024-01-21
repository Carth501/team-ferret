extends Control

@onready var node = $Control
@onready var node2 = $Control2

var center : Vector2

func _ready():
	center = Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y/2)

func _process(_delta):
	var tween = node.create_tween()
	var tween2 = node2.create_tween()
	var offset = center - get_global_mouse_position() * 0.1
	var offset2 = center - get_global_mouse_position() * 0.025
	tween.tween_property(node,"position",offset,1.0)
	tween2.tween_property(node2,"position",offset2,1.0)
