extends default_tree
class_name directory_tree

const TAGS = 1
const PATH = 2

const NOTHING = "nothing"
const FOLDERS = "folders"

export(NodePath) var root_node

export(bool) var show_tags = true

onready var root = get_node(root_node)

var column_names = { NAME: "Name", TAGS: "Tags", PATH: "Path" }

var path_column

var groups:Array


# Called when the node enters the scene tree for the first time.
func _ready():
	entries_selectable = true
	
	path_column = PATH if show_tags else TAGS
	
	entries = file_helper.list_files_in_directory(root.entry_directory, true, root.file_ending)
	
	for column in columns:
		set_column_title(column, column_names.get(column, ""))
	set_column_title(path_column, column_names[PATH])
	
	set_column_titles_visible(true)
	
	group_tree(FOLDERS)
	
	connect("item_activated", self, "open_entry")
	#get_node(root_node).connect("tab_changed", self, "_tab_changed")



func group_tree(group_by, filter = ""):
	match group_by:
		NOTHING:
			parse_tree(entries, tree_root, filter)
		FOLDERS:
			parse_tree(entries, tree_root, filter, PATH)
		_:
			parse_tree(entries, tree_root, filter, TAGS, group_by)


func parse(options, root_entry:TreeItem = tree_root, filter = "", group_by = null, category = null):
	groups.clear()
	
	var keys = options.keys() if typeof(options) == TYPE_DICTIONARY else options.size()
	var base_directory = ""
	
	if group_by == PATH:
		base_directory = "%s/" % [root.entry_directory]
	elif not group_by == null:
		base_directory = "%s/" % [root.entry_directory]
	
	for option in keys:
		var data = options[option]
		var tags_dictionary = json_helper.load_json(data).get("tags", { })
		
		if filter == "" or filter.to_lower() in data.to_lower() or check_array_for_filter(filter.to_lower(), tags_dictionary.values()):
			var place_in_tree:Array = [ ]
			
			if group_by == null:
				place_in_tree = [[data.get_file()]]
			elif category == null:
				place_in_tree = [data.trim_prefix(base_directory).split("/", false)]
			else:
				var array = tags_dictionary.get(category, "")
				
				for entry in array:
					place_in_tree.append(entry.plus_file(data.get_file()).split("/", false))
			
			for place in place_in_tree:
				parse_branch(place, root_entry, data, filter, tags_dictionary)


func open_entry(node = get_node(root_node).get_root_node()):
	if not get_selected().get_metadata(path_column) == null:
		node.open_new_tab(get_selected().get_metadata(path_column), get_selected().get_text(NAME))


func set_full_path(entry:TreeItem, full_path:String, tags_dictionary:Dictionary = { }):
	entry.set_text(path_column, full_path.trim_prefix(root.entry_directory + "/"))
	entry.set_metadata(path_column, full_path)
	
	if show_tags:
		entry.set_text(TAGS, extract_tags_from_array(tags_dictionary.values()))
		entry.set_metadata(TAGS, str(tags_dictionary))
	
	for tag in tags_dictionary:
		if not tag in groups:
			groups.append(tag)


func get_leaf_name(node_name:String) -> String:
	return node_name.trim_suffix(root.file_ending)
