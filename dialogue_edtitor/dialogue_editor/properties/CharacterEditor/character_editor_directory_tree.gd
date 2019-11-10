extends "res://dialogue_editor/properties/CharacterEditor/character_directory/character_directory_tree.gd"

func open_entry(node = get_node(root_node)):
	node.get_parent().open_new_tab(get_selected().get_text(0))
