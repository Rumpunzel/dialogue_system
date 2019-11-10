extends Tree

export(String, DIR) var conversations_directory

var conversations:Array

var root


# Called when the node enters the scene tree for the first time.
func _ready():
	conversations = file_helper.list_files_in_directory(conversations_directory, true)
	
	root = create_item()
	
	parse_tree(conversations, root)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func parse_tree(options, root_entry, column_offset = 0):
	var keys = options.keys() if typeof(options) == TYPE_DICTIONARY else options.size()
	
	for option in keys:
		var data = options[option]
		
		if typeof(data) == TYPE_DICTIONARY:
			parse_tree(data, root_entry, column_offset)
		else:
			var entry = create_item(root_entry)
			
			match typeof(data):
				TYPE_ARRAY:
					entry.set_text(column_offset, str(option))
					parse_tree(data, entry, column_offset)
				_:
					entry.set_text(column_offset, str(data))
