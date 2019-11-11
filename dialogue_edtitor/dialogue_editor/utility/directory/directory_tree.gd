extends Tree
class_name directory_tree

enum { NAME, TAGS, PATH }

const COLUMNS = { NAME: "Name", TAGS: "Tags", PATH: "Path" }

export(NodePath) var root_node

onready var root = get_node(root_node)

var entries

var tree_root


# Called when the node enters the scene tree for the first time.
func _ready():
	entries = file_helper.list_files_in_directory(root.entry_directory, true, root.file_ending)
	
	tree_root = create_item()
	
	for column in columns:
		set_column_title(column, COLUMNS.get(column, ""))
	
	set_column_titles_visible(true)
	
	parse_tree(entries, tree_root)
	
	connect("item_activated", self, "open_entry")
	#get_node(root_node).connect("tab_changed", self, "_tab_changed")


func parse_tree(options, root_entry):
	var keys = options.keys() if typeof(options) == TYPE_DICTIONARY else options.size()
	
	for option in keys:
		var data = options[option]
		var entry = create_item(root_entry)
		
		entry.set_text(NAME, str(data).get_file().trim_suffix(root.file_ending).capitalize())
		entry.set_text(PATH, str(data))

func open_entry(node = get_node(root_node).get_root_node()):
	node.open_new_tab(get_selected().get_text(PATH), get_selected().get_text(NAME))


func _tab_changed(_index):
	clear()
	parse_tree(entries, root)
