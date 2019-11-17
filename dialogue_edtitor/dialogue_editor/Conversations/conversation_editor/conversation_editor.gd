extends default_editor_tab

export(NodePath) var trees_container


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("new_json", get_node(trees_container), "update_trees")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
