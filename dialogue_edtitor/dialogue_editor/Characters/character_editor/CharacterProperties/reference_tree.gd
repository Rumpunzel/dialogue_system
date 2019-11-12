extends Tree

enum { NAME, VALUE }

export(NodePath) var root_node
export(Array, String) var values_to_exclude

onready var root = get_node(root_node)

var entries
var entry_map:Dictionary

var tree_root

signal tree_parsed


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(root_node).connect("current_NPC", self, "setup")



func setup(NPC):
	entries = json_helper.load_json(NPC.json_path)
	
	parse_tree(entries, tree_root)


func parse_tree(options, root_entry, filter = ""):
	clear()
	tree_root = create_item()
	
	for option in options:
		if not option in values_to_exclude:
			parse_branch([option] + parse(options[option]), root_entry, "", "", {})
	
	emit_signal("tree_parsed")

func parse(options):
	if typeof(options) == TYPE_ARRAY or typeof(options) == TYPE_DICTIONARY:
		for option in options.keys():
			return [option] + parse(options[option])
	else:
		return Array(str(options).split("/", false))


func parse_branch(branch:Array, root_entry, full_path, filter, tags_dictionary:Dictionary):
	var node_name = branch.pop_front()
	var entry
	
	if entry_map.get(node_name) == null:
		entry = create_item(root_entry)
		var leaf_name = node_name
	
		entry.set_text(NAME, leaf_name)
		entry.set_metadata(NAME, node_name)
		entry_map[leaf_name] = entry
	else:
		entry = entry_map.get(node_name)
	
	if branch.empty():
		pass
		#entry.set_text(PATH, full_path)
		#entry.set_metadata(PATH, full_path)
	
		#entry.set_text(TAGS, extract_tags_from_array(tags_dictionary.values()))
		#entry.set_metadata(TAGS, str(tags_dictionary))
	
		#for tag in tags_dictionary:
		#	if not tag in groups:
		#		groups.append(tag)
	else:
		parse_branch(branch, entry, full_path, filter, tags_dictionary)


func extract_tags_from_array(array):
	var return_string = ""
	
	for entry in array:
		var tags = entry.split("/", false)
		
		for tag in tags:
			return_string += "%s, " % [tag]#.capitalize()]
	
	return return_string.trim_suffix(", ")


func check_array_for_filter(filter, array):
	for entry in array:
		if filter in entry.to_lower():
			return true
	
	return false
