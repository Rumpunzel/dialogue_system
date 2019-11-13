extends PanelContainer


func setup_tree(tags_json, tag_name):
	var label = $tag_container/button_divider/label
	var reference_tree = $tag_container/reference_tree
	
	label.text = tag_name
	reference_tree.setup(tags_json)
