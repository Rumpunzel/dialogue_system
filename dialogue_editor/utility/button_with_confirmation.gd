extends Button
class_name ButtonWithConfirmation

export(String, MULTILINE) var confirmation_text

signal confirmed


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", self, "open_dialog")


func open_dialog():
	var dialog = create_dialog()
	
	dialog.connect("confirmed", self, "confirm_dialog")
	
	dialog.popup_centered()

func create_dialog():
	var dialog = ConfirmationDialog.new()
	
	dialog.dialog_text = confirmation_text
	dialog.popup_exclusive = true
	
	dialog.get_label().align = Label.ALIGN_CENTER
	dialog.get_label().valign = Label.VALIGN_CENTER
	
	add_child(dialog)
	
	return dialog

func confirm_dialog():
	emit_signal("confirmed")
