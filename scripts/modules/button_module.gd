class_name button_module
extends abstract_module

@onready var anim_button = $anim_button as AnimatedSprite2D

@export var rtl_object: RichTextLabel
@export var internal_button: Button

func set_label(label: String):
	rtl_object.clear()
	rtl_object.append_text(label)

func button_pressed():
	trigger.emit(control_def)
	play_animation()

func play_animation() -> void:
	anim_button.play("click")
