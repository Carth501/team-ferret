class_name transition_screen
extends CanvasLayer

signal transitioned
signal normality_restored

func _ready():
	$AnimationPlayer.play("fade_to_normal")

func transition():
	$AnimationPlayer.play("fade_to_black")
	
func _on_animation_player_animation_finished(anim_name):
	if(anim_name == "fade_to_black"):
		emit_signal("transitioned")
		$AnimationPlayer.play("fade_to_normal")
	else:
		normality_restored.emit()
