extends Button

export(PackedScene) var file_dialog

export(NodePath) var root_node

onready var current_image_path:String = get_node(root_node).default_portrait

signal new_image


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", self, "open_dialog")


func open_dialog():
	var dialog = create_dialog()
	
	dialog.connect("file_selected", self, "confirm_dialog")
	
	dialog.popup_centered_ratio(0.6)

func create_dialog():
	var dialog = file_dialog.instance()
	
	dialog.current_path = current_image_path
	
	add_child(dialog)
	
	return dialog

func confirm_dialog(selected_image):
	current_image_path = selected_image
	emit_signal("new_image", selected_image)
