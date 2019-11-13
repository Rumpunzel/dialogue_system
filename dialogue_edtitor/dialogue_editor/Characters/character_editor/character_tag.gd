extends PanelContainer


func setup_tree(NPC, tag_name):
	$tag_container/label.text = tag_name
	$tag_container/reference_tree.setup(NPC, tag_name)
