extends Button

export(PackedScene) var file_dialog

var current_image_path:String

signal new_image


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", self, "open_dialog")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


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
