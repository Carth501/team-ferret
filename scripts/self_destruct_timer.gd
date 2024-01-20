class_name self_destruct_timer extends Timer

func _ready():
	timeout.connect(end)

func end():
	queue_free()
