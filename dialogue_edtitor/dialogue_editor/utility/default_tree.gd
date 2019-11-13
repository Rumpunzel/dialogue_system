extends Tree
class_name default_tree

const NAME = 0

#warning-ignore:unused_class_variable
var entries
var entry_map:Dictionary

var tree_root

signal tree_parsed


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func parse_tree(options, root_entry:TreeItem = tree_root, filter:String = "", group_by = null, category = null):
	clear()
	entry_map.clear()
	tree_root = create_item()
	
	parse(options, root_entry, filter, group_by, category)
	
	emit_signal("tree_parsed")


func parse(_options, _root_entry:TreeItem = tree_root, _filter:String = "", _group_by = null, _category = null):
	pass


func parse_branch(branch:Array, root_entry:TreeItem, full_path:String = "", filter:String = "", tags_dictionary:Dictionary = { }):
	var node_name = branch.pop_front()
	var entry
	
	if entry_map.get(node_name) == null:
		entry = create_item(root_entry)
		var leaf_name = get_leaf_name(node_name)
		
		entry.set_text(NAME, leaf_name)
		entry.set_metadata(NAME, node_name)
		
		entry_map[leaf_name] = entry
	else:
		entry = entry_map.get(node_name)
	
	if not branch.empty():
		parse_branch(branch, entry, full_path, filter, tags_dictionary)
	else:
		set_full_path(entry, full_path, tags_dictionary)


func extract_tags_from_array(array:Array):
	var return_string = ""
	
	for entry in array:
		if not typeof(entry) == TYPE_ARRAY:
			var tags = entry.split("/", false)
			
			for tag in tags:
				return_string += "%s, " % [tag]
		else:
			return_string += "%s, " % [extract_tags_from_array(entry)]
	
	return return_string.trim_suffix(", ")


func check_array_for_filter(filter:String, array:Array):
	for entry in array:
		if filter in entry.to_lower():
			return true
	
	return false


func parse_dictionary_to_arrays_of_paths(dictionary:Dictionary):
	if dictionary.empty():
		return ""
	else:
		var array:Array = [ ]
		
		for key in dictionary.keys():
			var string = parse_dictionary_to_arrays_of_paths(dictionary[key])
			
			if typeof(string) == TYPE_ARRAY:
				for tag in string:
					array.append("%s/%s" % [key, tag])
			else:
				array.append("%s%s" % [key, ("/" + string) if not string == "" else ""])
		
		return array


func set_full_path(_entry:TreeItem, _full_path:String, _tags_dictionary:Dictionary = { }):
	pass


func get_leaf_name(node_name:String) -> String:
	return node_name
