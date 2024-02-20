class_name abstract_module extends Control

signal trigger(payload)
signal trigger_with_ref(ref)

var id: String
var control_def : Variant
@export var warning : warning_popup 
@export var hover_area : Control
var latches : Array[Variant]

func set_id(new_id: String):
	id = new_id

func set_control_def(new_control : Variant):
	control_def = new_control
	id = new_control.id
	if(new_control.has("warning_text")):
		warning.set_text(new_control.warning_text)
		hover_area.mouse_entered.connect(warning.show_panel)
		hover_area.mouse_exited.connect(warning.hide_panel)

func get_current_values():
	return {}

func set_value(setting):
	push_error(str(
		"abstract_module set_value called. Attempted to set value to ", setting))

func disable_for(duration : float):
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = duration
	timer.timeout.connect(enable)
	add_child(timer)
	timer.start()

func enable():
	push_error("abstract_module enable called.")

func config_latches():
	if(control_def == null):
		push_error("attempting to configure latches, but control def has not been set.")
	if(control_def.has("latches")):
		var latches_def = control_def.latches
		if(latches_def.has("disabled_if")):
			print("discovered a disabled_if latch")
			for condition in latches_def.disabled_if:
				var condition_id = condition.module_id
				var dependency = module_manager_single.get_module_obj(condition_id)
				if(dependency != null):
					var new_latch = {
						"type": "disabled_if",
						"module": dependency,
						"value": condition.value
					}
					latches.append(new_latch)

func check_latches_unlocked() -> bool:
	for latch in latches:
		if(latch.type == "disable_if"):
			var current_values = latch.to_be_set.module.get_current_values()
			if(current_values.value != latch.value):
				return false
	return true
