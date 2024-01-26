extends Control

@onready var splash = $Splash

@export_category("Splash Manager")
@export var _move_to: PackedScene
@export var _initial_delay := 1.0

var _splash_screens: Array[SplashScreen] = []

func _ready() -> void:
	assert(_move_to)
	set_process_input(false)
	
	for splash_screen in splash.get_children():
		splash_screen.hide()
		_splash_screens.push_back(splash_screen)
	
	await get_tree().create_timer(_initial_delay).timeout
	_start_splash_screen()
	set_process_input(true)

func _input(_event: InputEvent) -> void:
	if(Input.is_action_just_pressed("ui_skip")):
		_skip()

func _start_splash_screen() -> void:
	if(_splash_screens.size() == 0):
		get_tree().change_scene_to_packed(_move_to)
	else:
		var splash_screen: SplashScreen = _splash_screens.pop_front()
		splash_screen.start()
		splash_screen.connect("finished", _start_splash_screen)

func _skip() -> void:
	splash.get_child(0).queue_free()
	_start_splash_screen()
