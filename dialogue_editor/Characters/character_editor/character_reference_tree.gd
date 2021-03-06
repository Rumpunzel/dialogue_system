extends DefaultTree

var tag_name


func setup(NPC, tag_string):
	tag_name = tag_string
	var json = JSONHelper.load_json(NPC.json_path)
	
	if not json == null:
		entries = json.get("tags", { })
	
		parse_tree(entries)


func parse(options, root_entry:TreeItem = tree_root, _filter:String = "", _group_by = null, _category = null):
	var tag = options.get(tag_name, [ ])
	
	for values in tag:
		parse_branch(Array(values.split("/", false)), root_entry)
