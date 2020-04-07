extends ScrollContainer

export(PackedScene) var dialogue_message_scene

var tree_json


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func parse_tree(new_tree, new_name):
	var messages_container = $messages_container
	
	tree_json = new_tree
	name = new_name
	
	messages_container.get_node("tree_name").set_text(name)
	
	for thing in tree_json:
		var content = tree_json[thing]
		
		if typeof(content) == TYPE_ARRAY:
			var new_message = dialogue_message_scene.instance()
			messages_container.add_child(new_message)
			new_message.parse_message(content, thing)
