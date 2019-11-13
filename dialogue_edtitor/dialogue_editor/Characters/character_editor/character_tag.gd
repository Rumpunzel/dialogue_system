extends PanelContainer

export(NodePath) var label
export(NodePath) var reference_tree


func setup_tree(NPC, tag_name):
	get_node(label).text = tag_name
	get_node(reference_tree).setup(NPC, tag_name)
