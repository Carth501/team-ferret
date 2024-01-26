class_name settings extends Control

@onready var config := ConfigFile.new()
@onready var master_id := AudioServer.get_bus_index("Master")
@onready var music_id := AudioServer.get_bus_index("Music")
@onready var effects_id := AudioServer.get_bus_index("Effects")
@onready var toggle_fullscreen = $"TabContainer/    Graphics    /MarginContainer/VBoxContainer/View Settings/toggle_fullscreen" as Button

@export var master_volume: Slider
@export var music_volume: Slider
@export var effects_volume: Slider

var config_path := "user://settings.cfg"
var sound := "Sound"
var graphic := "Graphics"
var fullscreen:bool

const DEFAULT_MASTER_VOLUME = 1.0
const DEFAULT_MUSIC_VOLUME = 1.0
const DEFAULT_EFFECTS_VOLUME = 1.0
const DEFAULT_FULLSCREEN = false

func _ready():
	var err = config.load(config_path)
	if(err != OK):
		fullscreen = false
		save_config()
		config.has_v
	else:
		master_volume.value = config.get_value(sound, "master_volume", DEFAULT_MASTER_VOLUME)
		music_volume.value = config.get_value(sound, "music_volume", DEFAULT_MUSIC_VOLUME)
		effects_volume.value = config.get_value(sound, "effects_volume", DEFAULT_EFFECTS_VOLUME)
		fullscreen = config.get_value(graphic,"fullscreen", DEFAULT_FULLSCREEN)
		apply_volumes()
		apply_graphics()

func save_config():
		config.set_value(sound, "master_volume", master_volume.value)
		config.set_value(sound, "music_volume", music_volume.value)
		config.set_value(sound, "effects_volume", effects_volume.value)
		config.set_value(graphic,"fullscreen", fullscreen)
		config.save(config_path)
		apply_volumes()
		apply_graphics()

func apply_volumes():
	process_slider(master_volume, master_id)
	process_slider(music_volume, music_id)
	process_slider(effects_volume, effects_id)

func apply_graphics():
	toggle_fullscreen.button_pressed = fullscreen

func set_mute_bus(bus_id: int, setting: bool):
	AudioServer.set_bus_mute(bus_id, setting)

func process_slider(slider: Slider, bus_id: int):
	if(slider.value > 0):
		set_mute_bus(bus_id, false)
		var db = linear_to_db(slider.value/100)
		AudioServer.set_bus_volume_db(bus_id, db)
	else:
		set_mute_bus(bus_id, true)

func _on_toggle_fullscreen(toggled_on):
	if(toggled_on):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		fullscreen = true
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(Vector2i(1280,720))
		fullscreen = false
