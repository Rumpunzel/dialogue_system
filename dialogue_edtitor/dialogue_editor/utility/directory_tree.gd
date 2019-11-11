extends Tree
class_name directory_tree

enum { NAME, TAGS, PATH }

const COLUMNS = { NAME: "Name", TAGS: "Tags", PATH: "Path" }

export(String, DIR) var entry_directory

export(String) var file_ending

export(NodePath) var root_node

var entries

var root


# Called when the node enters the scene tree for the first time.
func _ready():
	entries = file_helper.list_files_in_directory(entry_directory, true, file_ending)
	
	root = create_item()
	
	for column in columns:
		set_column_title(column, COLUMNS.get(column, ""))
	
	set_column_titles_visible(true)
	
	parse_tree(entries, root)
	
	connect("item_activated", self, "open_entry")
	#get_node(root_node).connect("tab_changed", self, "_tab_changed")


func parse_tree(options, root_entry):
	var keys = options.keys() if typeof(options) == TYPE_DICTIONARY else options.size()
	
	for option in keys:
		var data = options[option]
		var entry = create_item(root_entry)
		
		entry.set_text(NAME, str(data).get_file().trim_suffix(file_ending).capitalize())
		entry.set_text(PATH, str(data))

func open_entry(node = get_node(root_node)):
	node.open_new_tab(get_selected().get_text(PATH), get_selected().get_text(NAME))


func _tab_changed(_index):
	clear()
	parse_tree(entries, root)
