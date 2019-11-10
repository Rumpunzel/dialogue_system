extends Tree
class_name directory_tree

export(String, DIR) var entry_directory

export(String) var file_ending

export(NodePath) var root_node

var entries

var root


# Called when the node enters the scene tree for the first time.
func _ready():
	entries = file_helper.list_files_in_directory(entry_directory, true, file_ending)
	
	root = create_item()
	root.set_text(0, entry_directory.get_file())
	
	parse_tree(entries, root)
	
	connect("item_activated", self, "open_entry")
	#get_node(root_node).connect("tab_changed", self, "_tab_changed")


func parse_tree(options, root_entry, column_offset = 0):
	var keys = options.keys() if typeof(options) == TYPE_DICTIONARY else options.size()
	
	for option in keys:
		var data = options[option]
		
		if not data.get_base_dir().get_file() == root_entry.get_text(column_offset).get_file():
			var entry = create_item(root_entry)
			
			entry.set_text(column_offset, str(data).get_base_dir().get_file())
			parse_tree([data], entry, column_offset)
		else:
			var entry = create_item(root_entry)
			
			entry.set_text(column_offset, str(data).get_file().trim_suffix(file_ending))
			entry.set_text(column_offset + 1, str(data))

func open_entry(node = get_node(root_node)):
	node.open_new_tab(get_selected().get_text(1), get_selected().get_text(0))


func _tab_changed(_index):
	clear()
	parse_tree(entries, root)
