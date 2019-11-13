extends default_tree

const VALUE = 1


func setup(tags_json):
	entries = tags_json
	
	for entry in entries.keys():
		parse_tree(entries)


func parse(options, root_entry:TreeItem = tree_root, _filter:String = "", _group_by = null, _category = null):
	var tag = parse_dictionary_to_arrays_of_paths(options)
	
	for values in tag:
		parse_branch(values.split("/", false), root_entry)
