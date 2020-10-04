class_name EditorTag
extends PanelContainer



func setup_tree(tags_json, tag_name: String):
	var label = $tag_container/button_divider/label
	var button = $tag_container/button_divider/button
	var reference_tree = $tag_container/reference_tree
	
	label.text = tag_name.capitalize()
	reference_tree.setup(tags_json)
	
	button.connect("toggled", reference_tree, "set_editable")
