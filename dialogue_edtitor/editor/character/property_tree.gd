extends Tree

var root
var perception_values

# Called when the node enters the scene tree for the first time.
func _ready():
	root = create_item()
	root.set_text(0, "ROOT")
	
	perception_values = create_item(root)
	perception_values.set_text(0, "Perception Values")
	perception_values.set_editable(1, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
