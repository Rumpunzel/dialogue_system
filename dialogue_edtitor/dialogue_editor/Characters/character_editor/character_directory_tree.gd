extends directory_tree

func open_entry(node = get_node(root_node)):
	.open_entry(node.get_parent())
