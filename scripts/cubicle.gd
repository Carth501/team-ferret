class_name cubicle extends Node

@onready var options_menu = $options_menu as Control
@onready var open_options = $"pause curtain/open_options" as Button

signal diagetic_error_report(new_error)
signal diagetic_error_resolved(error_id)
signal modules_ready()

@export var control_panel: Control
@export var timer_corral: Node
@export var game_timer: Timer
@export var error_factory_controller: error_factory
@export var manual_instance: manual
@export var level_clock_handler: level_clock
@onready var pause_curtain := $"pause curtain"
@onready var pause_button := $"ScrollContainer/Module Panel/Pause Button"
@onready var resume_button := $"pause curtain/Resume Button"
@onready var level_music := $"Level Music"
@onready var danger_music := $"Danger Music"
@onready var cpc_calc := $CpcCalculator
@onready var error_arrived := $"Sound Effects/Error Arrived"
@onready var error_resolved := $"Sound Effects/Error Resolved"
@onready var simulation_screen := $Cubicle/Background/GameScreen
@onready var simulation_shaders := $Cubicle/Background/GameScreen/Screen_Shaders
@onready var pager_ref := $pager
@onready var complete_level_cheat := $"pause curtain/complete level"
@onready var side_effects := side_effect_manager.new()
var current_level_id: String
var current_level
var error_schedule := []
var error_catalogue := []
var error_timers_list := []
var failure_threshold_percent: float
var paused := false
var met_target := false
var module_triggers := 0
var repeat_attempt := false
var results_struct := {
	"met_target": false,
	"errors_cleared": 0,
	"module_miss_count": 0,
	"modules_per_minute": 0,
	"repeat_attempt": false
}

func _ready():
	handle_connecting_signals()
	if(!data_libraries_single.ready):
		await data_libraries_single.ready
	if(!level_loader_single.ready):
		await level_loader_single.ready
	level_loader_single.cubicle_ready(self)
	if(pause_button == null):
		push_error("pause_button not hooked up")
	else:
		pause_button.internal_button.pressed.connect(toggle_pause)
	if(resume_button == null):
		push_error("resume_button not hooked up")
	else:
		resume_button.internal_button.pressed.connect(toggle_pause)
	if(OS.is_debug_build()):
		complete_level_cheat.visible = true
	else:
		complete_level_cheat.queue_free()
	add_child(side_effects)
	side_effects.set_cpc_calc(cpc_calc)
	side_effects.set_sim_screen(simulation_screen)
	side_effects.set_error_factory(error_factory_controller)

func load_level(level_id: String = "test"):
	module_manager_single.clear()
	current_level_id = level_id
	get_level()
	detect_repeat_attempt()
	get_error_schedule(current_level)
	get_error_catalogue(current_level)
	var module_list : Array[String] = create_module_id_list()
	create_module_objects(module_list)
	create_error_timers()
	set_initial_module_settings()
	populate_error_factory()
	configure_level_settings()
	tutorial_init()
	upgrade_init()
	
func get_level():
	var level_list = data_libraries_single.level_data
	for level in level_list:
		var metadata = level.metadata
		if (metadata.id == current_level_id):
			current_level = level 
			return

func detect_repeat_attempt():
	var complete_levels = save_handler_single.active_save.complete_levels
	repeat_attempt = complete_levels.has(current_level_id)

func configure_level_settings():
	if(current_level.gameplay.has("starting_cpc")):
		cpc_calc.set_cpc(current_level.gameplay.starting_cpc)
	if(current_level.gameplay.has("goal_cpc")):
		cpc_calc.set_target(current_level.gameplay.goal_cpc)
	if(current_level.gameplay.has("shift_duration")):
		var shift_duration = current_level.gameplay.shift_duration
		level_clock_handler.set_value(shift_duration)
		create_danger_timer(shift_duration)
	if(current_level.gameplay.has("failure_threshold_percent")):
		var value = current_level.gameplay.failure_threshold_percent
		if(value >= 0):
			cpc_calc.set_threshold(value)
	if(current_level.metadata.has("music")):
		var track = "res://assets/audio/music/" + current_level.metadata.music + ".mp3"
		var song = load(track)
		level_music.stream = song
		level_music.play()
	if(current_level.gameplay.has("error_freq")):
		error_factory_controller.set_error_freq(current_level.gameplay.error_freq)

func get_error_schedule(level):
	var error_id_schedule = level.gameplay.errors.scheduled
	for error in error_id_schedule:
		var error_item = dereferencer_single.error_by_id(error.id)
		if(error.has("time")):
			error_item["time"] = error.time
			error_schedule.append(error_item)
		else:
			error_factory_controller.create_error_node(error_item)

func get_error_catalogue(level):
	if(!level.gameplay.has("errors")):
		push_warning("level has no errors list, was this intentional?")
	var error_id_list = level.gameplay.errors.random
	for error in error_id_list:
		var dereferenced = dereferencer_single.error_by_id(error)
		error_catalogue.append(dereferenced)

func create_module_id_list() -> Array[String]:
	var list : Array[String] = []
	for error in error_schedule:
		for step in error.pattern:
			if !list.has(step.id):
				list.append(step.id)
	for error in error_catalogue:
		for step in error.pattern:
			if !list.has(step.id):
				list.append(step.id)
	return list

func create_module_objects(module_list: Array[String]):
	for module_id in module_list:
		var new_module_list = module_manager_single.create_module_with_id(module_id)
		for new_module in new_module_list:
			control_panel.add_child(new_module)
			new_module.trigger.connect(count_module_triggers)
			modules_ready.connect(new_module.config_latches)
			side_effects.register_side_effects(new_module)
			var spacing = 10
			var offset = new_module.control_def.offset
			var x_pos = offset[0] * 64 + offset[0] * spacing
			var y_pos = offset[1] * 64 + offset[1] * spacing
			new_module.position = Vector2(x_pos, y_pos)
	modules_ready.emit()

func create_error_timers():
	for error in error_schedule:
		var timer := self_destruct_timer.new()
		timer_corral.add_child(timer)
		timer.wait_time = error.time
		timer.one_shot = true
		timer.autostart = true
		error_timers_list.append(timer)
		timer.timeout.connect(next_error_report)

func next_error_report():
	var new_error = error_schedule.pop_front()
	diagetic_error_report.emit(new_error)
	error_arrived.play()

func error_report(_error: active_error):
	if(error_arrived.is_inside_tree()):
		error_arrived.play()

func announce_error_resolved(error_id):
	results_struct.errors_cleared += 1
	diagetic_error_resolved.emit(error_id)
	error_resolved.play()

func set_initial_module_settings():
	if(current_level.has("init_values")):
		for key in current_level.init_values:
			var module = module_manager_single.module_obj_dic[key]
			if(module == null):
				push_error(str("current_level.init_values has key ", key, 
				" not found in module_manager_single.module_obj_dic"))
			module.set_value(current_level.init_values[key])

func populate_error_factory():
	error_factory_controller.set_error_list(error_catalogue)

func toggle_pause():
	paused = !paused
	pause_curtain.visible = paused
	if(paused):
		stop_timers()
		simulation_screen.speed_scale = 0
		simulation_shaders.visible = false
	else:
		start_timers()
		simulation_screen.speed_scale = 1
		simulation_shaders.visible = true

func stop_timers():
	game_timer.stop()
	for timer in error_timers_list:
		if(timer != null):
			timer.paused = true

func start_timers():
	game_timer.start()
	for timer in error_timers_list:
		if(timer != null):
			timer.paused = false

func end_level():
	save_handler_single.shift_to_game_menu()

func complete_level():
	save_handler_single.level_complete(current_level.metadata.id)

func create_danger_timer(duration: float):
	var danger_timer = Timer.new()
	danger_timer.name = "Danger Timer"
	add_child(danger_timer)
	danger_timer.wait_time = max(duration * 0.9 - 10, 10)
	danger_timer.one_shot = true
	danger_timer.start()
	danger_timer.timeout.connect(start_danger_music)
	error_timers_list.append(danger_timer)

func start_danger_music():
	level_music.stop()
	danger_music.play()

func met_target_cpc():
	met_target = true
	save_handler_single.level_complete(current_level.metadata.id)

func end_of_shift():
	toggle_pause()
	resume_button.visible = false
	results_struct.met_target = met_target
	results_struct.repeat_attempt = repeat_attempt
	var level_duration_minutes = (current_level.gameplay.shift_duration / 60)
	results_struct.modules_per_minute = module_triggers / level_duration_minutes
	results_single.results_struct = results_struct
	var tree = get_tree()
	tree.change_scene_to_file("res://scenes/end_day.tscn")

func failure():
	end_of_shift()

func handle_connecting_signals() -> void:
	open_options.button_down.connect(on_options_pressed)
	options_menu.exit_options_menu.connect(on_exit_options_menu)

func on_options_pressed():
	options_menu.set_process(true)
	options_menu.visible = true

func on_exit_options_menu() -> void:
	options_menu.visible = false

func count_module_triggers(_payload):
	module_triggers += 1

func tutorial_init():
	if(current_level.metadata.has("tutorial") && current_level.metadata.tutorial):
		var tutorial_scene = load("res://scenes/tutorial.tscn")
		var node_tutorial = tutorial_scene.instantiate()
		node_tutorial.name = "tutorial"
		add_child(node_tutorial)
		node_tutorial.set_cubicle(self)

func upgrade_init():
	if(!current_level.metadata.has("tutorial") || !current_level.metadata.tutorial):
		var active_save = save_handler_single.active_save
		var upgrades = active_save.upgrades
		level_clock_handler.visible = upgrades.has("digital_clock") && upgrades.digital_clock
		pager_ref.toggle_extra_button(upgrades.has("pager_buttons") && upgrades.pager_buttons)

func is_error_in_level(id : String) -> bool:
	for error in error_schedule:
		if(error.id == id):
			return true
	for error in error_catalogue:
		if(error.id == id):
			return true
	return false
