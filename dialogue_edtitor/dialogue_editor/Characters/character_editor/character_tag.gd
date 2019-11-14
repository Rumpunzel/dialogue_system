extends tag


func setup_tree(NPC, tag_name):
	var label = $tag_container/button_divider/label
	var reference_tree = $tag_container/reference_tree
	
	label.text = tag_name
	reference_tree.setup(NPC, tag_name)
