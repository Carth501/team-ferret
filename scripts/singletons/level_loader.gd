class_name level_loader extends Node

var cubicle_instance: cubicle
var next_level_id: String

func load_level(id: String):
	next_level_id = id
	transition_screen_single.transitioned.connect(go_to_cubicle)
	transition_screen_single.transition()

func load_continue():
	load_level("L_RING-1")

func cubicle_ready(new_cubicle: cubicle):
	cubicle_instance = new_cubicle
	if(next_level_id != null && next_level_id != ""):
		cubicle_instance.load_level(next_level_id)
	else:
		cubicle_instance.load_level()

func go_to_cubicle():
	var tree = get_tree()
	var error = tree.change_scene_to_file("res://scenes/cubicle.tscn")
	if(error != OK):
		push_error(str("level_loader ", error))
	transition_screen_single.transitioned.disconnect(go_to_cubicle)
