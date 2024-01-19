class_name level_loader extends Node

var cubicle_instance: cubicle
var next_level_id: String

func load_level(id: String):
	next_level_id = id
	var tree = get_tree()
	var error = tree.change_scene_to_file("res://scenes/cubicle.tscn")

func load_continue():
	load_level("ring-1")

func cubicle_ready(new_cubicle: cubicle):
	cubicle_instance = new_cubicle
	if(next_level_id != null && next_level_id != ""):
		cubicle_instance.load_level(next_level_id)
	else:
		cubicle_instance.load_level()
