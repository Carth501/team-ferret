class_name settings extends Control

@onready var config := ConfigFile.new()
@onready var master_id := AudioServer.get_bus_index("Master")
@onready var music_id := AudioServer.get_bus_index("Music")
@onready var effects_id := AudioServer.get_bus_index("Effects")
@export var master_volume: Slider
@export var music_volume: Slider
@export var effects_volume: Slider
var config_path := "user://settings.cfg"
var sound := "Sound"

func _ready():
	var err = config.load(config_path)
	if(err != OK):
		save_config()
	else:
		master_volume.value = config.get_value(sound, "master_volume")
		music_volume.value = config.get_value(sound, "music_volume")
		effects_volume.value = config.get_value(sound, "effects_volume")
		apply_volumes()

func save_config():
		config.set_value(sound, "master_volume", master_volume.value)
		config.set_value(sound, "music_volume", music_volume.value)
		config.set_value(sound, "effects_volume", effects_volume.value)
		config.save(config_path)
		print("save_config")
		apply_volumes()

func apply_volumes():
	process_slider(master_volume, master_id)
	process_slider(music_volume, music_id)
	process_slider(effects_volume, effects_id)
	
func set_mute_bus(bus_id: int, setting: bool):
	AudioServer.set_bus_mute(bus_id, setting)

func process_slider(slider: Slider, bus_id: int):
	if(slider.value > 0):
		set_mute_bus(bus_id, false)
		var db = linear_to_db(slider.value/100)
		AudioServer.set_bus_volume_db(bus_id, db)
	else:
		set_mute_bus(bus_id, true)
