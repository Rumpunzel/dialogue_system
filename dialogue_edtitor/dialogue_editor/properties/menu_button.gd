extends MenuButton

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	get_popup().add_item("Duplicate")
	
	get_popup().add_separator()
	
	get_popup().add_item("Delete")
	
	get_popup().add_separator()
	
	get_popup().add_item("Close")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
