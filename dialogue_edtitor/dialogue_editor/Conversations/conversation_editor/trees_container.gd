extends TabContainer

export(PackedScene) var dialogue_tree_scene

var trees_json


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func update_trees(new_json):
	trees_json = new_json
	
	for tree in trees_json:
		create_tree_panel(trees_json[tree], tree)
	
	

func create_tree_panel(tree_json, tree_name):
	var new_tree = dialogue_tree_scene.instance()
	new_tree.parse_tree(tree_json, tree_name)
	add_child(new_tree)
