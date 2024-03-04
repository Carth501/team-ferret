class_name alert_popup extends Control

@export var sprite : AnimatedSprite2D

func show_alert():
	sprite.visible = true
	sprite.play("open")

func open_complete():
	sprite.play("loop")

func close_alert():
	sprite.visible = false
