extends Tree

enum { NAME, VALUE }

var entries
var entry_map:Dictionary

var tree_root

signal tree_parsed


func setup(NPC, tag_name):
	entries = json_helper.load_json(NPC.json_path).get("tags", { })
	
	parse_tree(entries, tag_name)


func parse_tree(options, tag_name):
	clear()
	entry_map.clear()
	tree_root = create_item()
	
	var tag = options.get(tag_name, [ ])
	
	for values in tag:
		parse_branch(Array(values.split("/", false)), tree_root)
	
	emit_signal("tree_parsed")

func parse(options):
	if typeof(options) == TYPE_ARRAY or typeof(options) == TYPE_DICTIONARY:
		for option in options.keys():
			return [option] + parse(options[option])
	else:
		return Array(str(options).split("/", false))


func parse_branch(branch:Array, root_entry):
	var node_name = branch.pop_front()
	var entry
	
	if entry_map.get(node_name) == null:
		entry = create_item(root_entry)
		var leaf_name = node_name
		
		entry.set_text(NAME, leaf_name)
		entry.set_metadata(NAME, node_name)
		entry.set_editable(NAME, true)
		
		entry_map[leaf_name] = entry
	else:
		entry = entry_map.get(node_name)
	
	if not branch.empty():
		parse_branch(branch, entry)


func extract_tags_from_array(array):
	var return_string = ""
	
	for entry in array:
		var tags = entry.split("/", false)
		
		for tag in tags:
			return_string += "%s, " % [tag]
	
	return return_string.trim_suffix(", ")


func check_array_for_filter(filter, array):
	for entry in array:
		if filter in entry.to_lower():
			return true
	
	return false
