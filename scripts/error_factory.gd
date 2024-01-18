class_name error_factory extends Node

signal update_active_error_count(int)
signal new_active_error(Variant)

@export var cubicle_instance: cubicle
var active_error_count = 0
var concurrent_player_count = 0
var error_list: Array = []
var rng = RandomNumberGenerator.new()
@export var probability: float = 0.1

func _ready():
	if(cubicle_instance == null):
		push_error("error factory doesn't have a reference to the cubicle.")

func set_error_list(error_catalogue):
	error_list = error_catalogue

func create_error_node(error):
	var new_error = active_error.new()
	add_child(new_error)
	new_error.set_id(error.id)
	new_error.set_pattern(error.pattern)
	new_error.connect_to_cubicle(cubicle_instance)
	active_error_count += 1
	new_error.resolved_error.connect(decrement_error_count)
	update_active_error_count.emit(active_error_count)
	new_active_error.emit(error)

func decrement_error_count(id):
	active_error_count -= 1
	update_active_error_count.emit(active_error_count)

func get_active_error_count() -> int:
	return active_error_count

func set_cpc(value: int):
	concurrent_player_count = value
	roll_new_error()

func roll_new_error():
	rng.seed = concurrent_player_count
	var roll = rng.randf()
	var probability_offset = log(concurrent_player_count) / 100
	var adjusted_probability = probability + probability_offset
	if(roll < adjusted_probability):
		generate_new_error(roll * (1 / adjusted_probability))

func generate_new_error(error_roll: float):
	if(error_list.size() == 0):
		push_warning("error_list size is 0. was that intentional?")
		return
	var index = floori(error_roll * error_list.size())
	create_error_node(error_list[index])
