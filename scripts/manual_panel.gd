extends Panel

var drag_offset: Vector2
var initial_position: Vector2
var mouse_over: bool = false
var holding: bool = false

func _on_gui_input(event):
	if(event is InputEventMouseButton):
		if(event.is_pressed() && mouse_over):
			drag_offset = get_viewport().get_mouse_position()
			initial_position = position
			holding = true
		else:
			holding = false
	elif(event is InputEventMouseMotion):
		if(holding):
			var delta_position = get_viewport().get_mouse_position() - drag_offset
			position = initial_position + delta_position 

func _on_mouse_entered():
	mouse_over = true

func _on_mouse_exited():
	mouse_over = false
