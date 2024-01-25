class_name load_manager extends Panel

var saves: Array[Variant]
var save_buttons: Array[generic_button] = []
@onready var save_container := $ScrollContainer/VBoxContainer
var index_selected := 0
var something_selected := false
@onready var highlight_theme := Theme.new()

func _ready():
	saves = save_handler_single.save_data # pass by ref
	highlight_theme.set_color("highlight", "Button", Color(0, 0, 0))

func build():
	var index = 0
	for save in saves:
		var save_selection_button = generic_button.new()
		save_selection_button.set_string(str(index))
		save_selection_button.set_label(save.name)
		save_container.add_child(save_selection_button)
		save_selection_button.text = save.name
		save_selection_button.button_press.connect(select_save)
		save_buttons.append(save_selection_button)

func select_save(index: String):
	var int_index = int(index)
	if(index_selected != int_index || something_selected == false):
		unhighlight_button(save_buttons[index_selected])
		index_selected = int_index
		something_selected = true
		highlight_button(save_buttons[index_selected])
	else:
		unhighlight_button(save_buttons[index_selected])
		something_selected = false

func highlight_button(save_button: generic_button):
	save_button.set_theme(highlight_theme)

func unhighlight_button(save_button: generic_button):
	save_button.theme = null
