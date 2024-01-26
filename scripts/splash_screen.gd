class_name SplashScreen
extends Control

@export_category("Splash Screen")
@export var _time := 3.0
@export var _fade_time := 1.0

signal finished()

func start() -> void:
	modulate.a = 0
	show()
	var tween: Tween = create_tween()
	tween.connect("finished", _finish)
	tween.tween_property(self, "modulate:a", 1, _fade_time)
	tween.tween_interval(_time)
	tween.tween_property(self, "modulate:a", 0, _fade_time)
	
func _finish() -> void:
	emit_signal("finished")
	queue_free()
