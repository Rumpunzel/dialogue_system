extends PanelContainer

export(String) var tag_name

export(NodePath) var root_node


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(root_node).connect("current_NPC", self, "setup_tree")
	
	$tag_container/label.text = tag_name

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func setup_tree(NPC):
	$tag_container/reference_tree.setup(NPC, tag_name)
