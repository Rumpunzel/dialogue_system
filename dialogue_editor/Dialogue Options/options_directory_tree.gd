extends Tree

export(String, FILE, "*.json") var dialogue_options_file_path

var dialogue_options: Dictionary

var root


# Called when the node enters the scene tree for the first time.
func _ready():
	dialogue_options = JSONHelper.load_json(dialogue_options_file_path)
	
	root = create_item()
	
	parse_tree(dialogue_options, root)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func parse_tree(options, root_entry, column_offset = 0):
	var keys = options.keys() if typeof(options) == TYPE_DICTIONARY else options.size()
	
	for option in keys:
		var data = options[option]
		var entry = create_item(root_entry)
		
		if not typeof(option) == TYPE_INT:
			entry.set_text(column_offset, str(option))
		
		if typeof(data) == TYPE_DICTIONARY:
			parse_tree(data, entry, column_offset)
		else:
			match typeof(data):
				TYPE_ARRAY:
					parse_tree(data, entry, column_offset)
				_:
					entry.set_text(column_offset + 1, str(data))
		
		entry.collapsed = true
