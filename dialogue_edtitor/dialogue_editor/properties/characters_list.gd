extends VBoxContainer

export(PackedScene) var character_entry = preload("res://dialogue_editor/properties/character_entry.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	load_entries()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	load_entries()


func load_entries():
	var json_path = Character.json_paths[Character.STATS_PATHS.MODIFIED]
	var loaded_json = json_helper.load_json(json_path)
	
	for entry in loaded_json.keys():
		if not has_entry(entry):
			var new_entry = character_entry.instance()
			new_entry.init(entry)
			add_child(new_entry)

func has_entry(entry_name:String):
	for entry in get_children():
		if entry.name == entry_name:
			return true
	
	return false
