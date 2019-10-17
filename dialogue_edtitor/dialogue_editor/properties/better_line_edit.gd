tool
extends LineEdit
class_name BetterLineEdit

export var expand = false
export var blink = true
export var clear_button = true
export(float) var space_size = 35

signal text_confirmed


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("text_entered", self, "confirm_text")
	connect("focus_exited", self, "confirm_text")
	connect("text_changed", self, "modify_minimum_size")
	
	modify_minimum_size(text)
	
	caret_blink = blink
	clear_button_enabled = clear_button

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func confirm_text(new_text = text):
	emit_signal("text_confirmed", new_text)
	
	release_focus()

func modify_minimum_size(new_text:String):
	if expand:
		new_text = new_text if new_text.length() > placeholder_text.length() else placeholder_text
		rect_min_size.x = max(get_minimum_size().x, get_font("font").get_string_size(new_text).x + space_size)
