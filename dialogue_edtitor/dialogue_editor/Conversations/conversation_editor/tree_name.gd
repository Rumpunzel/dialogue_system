extends BetterLineEdit

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func set_text(new_text):
	text = new_text
	
	if text == CONSTANTS.DEFAULT_TREE:
		editable = false