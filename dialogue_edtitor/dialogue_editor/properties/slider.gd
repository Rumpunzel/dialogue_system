extends HSlider

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("gui_input", self, "on_gui_input")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func on_gui_input(event):
	if event is InputEventMouseButton and event.doubleclick:
		value = 0
