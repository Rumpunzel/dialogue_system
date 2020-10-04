extends MarginContainer


export(String, DIR) var entry_directory

export(String) var file_ending

export(NodePath) var root_node



func get_root_node():
	return get_node(root_node)
