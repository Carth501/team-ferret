class_name button_module
extends abstract_module

@onready var anim_button = $anim_button as AnimatedSprite2D

@export var rtl_object: RichTextLabel
@export var internal_button: Button
var disabled := false

func set_label(label: String):
	rtl_object.clear()
	rtl_object.append_text(label)

func button_pressed():
	if(!disabled):
		trigger.emit(control_def)
		trigger_with_ref.emit(self)
		play_animation()

func play_animation() -> void:
	anim_button.play("click")

func disable_for(duration : float):
	super.disable_for(duration)
	disabled = true

func enable():
	disabled = false
