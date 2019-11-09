extends PanelContainer

export(NodePath) var portrait_node

export(NodePath) var change_button
export(NodePath) var reset_button

export(Texture) var default_portrait

onready var portrait = get_node(portrait_node)

var portrait_path:String

signal new_portrait


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(change_button).connect("new_image", self, "set_portrait")
	get_node(reset_button).connect("confirmed", self, "reset_portrait")


func reset_portrait():
	set_portrait("")

func set_portrait(new_portrait_path:String, initializing = false):
	portrait_path = new_portrait_path
	
	if portrait_path.length() > 0:
		portrait.texture = load(portrait_path)
	else:
		portrait.texture = default_portrait
	
	if not initializing:
		emit_signal("new_portrait", portrait_path)
