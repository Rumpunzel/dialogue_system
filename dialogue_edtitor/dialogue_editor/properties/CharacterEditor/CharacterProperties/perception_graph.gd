extends perception_graph

export(NodePath) var root_node


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(root_node).connect("current_NPC", self, "set_subject")


func set_subject(new_subject):
	subject = new_subject
