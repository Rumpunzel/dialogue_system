extends MarginContainer

export(String, DIR) var entry_directory setget set_entry_directory, get_entry_directory

export(String) var file_ending setget set_file_ending, get_file_ending

export(NodePath) var root_node


func set_entry_directory(new_directory:String):
	entry_directory = new_directory

func set_file_ending(new_ending:String):
	file_ending = new_ending


func get_entry_directory() -> String:
	return entry_directory

func get_file_ending() -> String:
	return file_ending

func get_root_node():
	return get_node(root_node)
