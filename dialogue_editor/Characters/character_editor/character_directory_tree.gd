extends DirectoryTree


func open_entry(node = get_node(root_node).get_root_node()):
	.open_entry(node.get_parent())
