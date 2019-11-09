extends TextEdit
class_name BetterTextEdit

signal new_text


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("text_changed", self, "confirm_text")
	connect("focus_exited", self, "confirm_text")


func confirm_text(new_text = text):
	emit_signal("new_text", new_text)
