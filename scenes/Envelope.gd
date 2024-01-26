extends Control

@export var open: TextureRect
@export var tab: TextureRect
@export var closed: TextureRect
var motion := Vector2(0, 0)

func _process(delta):
	position += motion * delta

func _ready():
	print("ready")
	var timer = Timer.new()
	timer.wait_time = 1
	timer.timeout.connect(open_envelope)
	add_child(timer)
	timer.one_shot = true
	timer.start()

func open_envelope():
	closed.visible = false
	open.visible = true
	tab.visible = false
	var timer = Timer.new()
	timer.wait_time = 0.5
	timer.timeout.connect(start_moving)
	add_child(timer)
	timer.one_shot = true
	timer.start()

func start_moving():
	motion = Vector2(-1400, 0)
	var timer = Timer.new()
	timer.wait_time = 8
	timer.timeout.connect(delete)
	add_child(timer)
	timer.one_shot = true
	timer.start()

func delete():
	queue_free()
