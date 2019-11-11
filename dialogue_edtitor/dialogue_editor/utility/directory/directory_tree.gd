extends Tree
class_name directory_tree

enum { NAME, TAGS, PATH }

const NOTHING = "nothing"
const FOLDERS = "folders"

const COLUMNS = { NAME: "Name", TAGS: "Tags", PATH: "Path" }

export(NodePath) var root_node

onready var root = get_node(root_node)

var entries
var entry_map:Dictionary

var tree_root


# Called when the node enters the scene tree for the first time.
func _ready():
	entries = file_helper.list_files_in_directory(root.entry_directory, true, root.file_ending)
	
	for column in columns:
		set_column_title(column, COLUMNS.get(column, ""))
	
	set_column_titles_visible(true)
	
	group_tree(FOLDERS)
	
	connect("item_activated", self, "open_entry")
	#get_node(root_node).connect("tab_changed", self, "_tab_changed")


func parse_tree(options, root_entry, filter, group_by = null, category = null):
	clear()
	entry_map = { }
	tree_root = create_item()
	
	var keys = options.keys() if typeof(options) == TYPE_DICTIONARY else options.size()
	var base_directory = ""
	
	if group_by == PATH:
		base_directory = "%s/" % [root.entry_directory]
	elif not group_by == null:
		pass
	
	for option in keys:
		var data = options[option]
		
		if filter == "" or filter.to_lower() in data.to_lower():
			var place_in_tree
			
			if group_by == null:
				place_in_tree = [data.get_file()]
			elif category == null:
				place_in_tree = data.trim_prefix(base_directory).split("/", false)
			else:
				place_in_tree = []
			
			parse_branch(place_in_tree, root_entry, data, filter)

func parse_branch(branch:Array, root_entry, full_path, filter):
	var node_name = branch.pop_front()
	var entry
	
	if entry_map.get(node_name) == null:
		entry = create_item(root_entry)
		var leaf_name = node_name.trim_suffix(root.file_ending)
		
		entry.set_text(NAME, leaf_name)
		entry_map[leaf_name] = entry
	else:
		entry = entry_map.get(node_name)
	
	if branch.empty():
		entry.set_text(PATH, full_path)
	else:
		parse_branch(branch, entry, full_path, filter)

func group_tree(group_by, filter = ""):
	match group_by:
		NOTHING:
			parse_tree(entries, tree_root, filter)
		FOLDERS:
			parse_tree(entries, tree_root, filter, PATH)
		_:
			parse_tree(entries, tree_root, filter, TAGS, group_by)

func open_entry(node = get_node(root_node).get_root_node()):
	node.open_new_tab(get_selected().get_text(PATH), get_selected().get_text(NAME))
