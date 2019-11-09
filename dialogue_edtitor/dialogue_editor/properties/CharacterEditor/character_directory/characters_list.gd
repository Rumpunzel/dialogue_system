extends VBoxContainer

export(PackedScene) var character_entry = preload("res://dialogue_editor/properties/CharacterEditor/character_directory/character_entry.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	load_entries()#

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	load_entries()


func load_entries():
	var json_path = Character.json_paths[Character.STATS_PATHS.MODIFIED]
	var loaded_json = json_helper.load_json(json_path)
	
	for entry in get_children():
		if not loaded_json.has(entry.name):
			remove_child(entry)
			entry.queue_free()
	
	for entry in loaded_json.keys():
		if has_entry(entry) < 0:
			var new_entry = character_entry.instance()
			new_entry.init(entry)
			add_child_alphabetically(new_entry)

func has_entry(entry_name:String):
	var entries = get_children()
	
	for i in entries.size():
		if entries[i].name == entry_name:
			return i
	
	return -1

func add_child_alphabetically(new_child):
	var children = get_children()
	
	if children.empty():
		add_child(new_child)
	else:
		for i in children.size():
			if new_child.name <= children[i].name:
				add_child(new_child)
				move_child(new_child, i)
				break
			elif i == children.size() - 1:
				add_child(new_child)
