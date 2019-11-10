extends default_editor_tab
class_name character_editor

export(NodePath) var portrait
export(NodePath) var bio

onready var NPC:NPC = $NPC

signal current_NPC


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(portrait).connect("new_portrait", NPC, "set_portrait_path")
	get_node(bio).connect("new_bio", NPC, "set_bio")


func setup(id:String):
	.setup(id)
	
	emit_signal("current_NPC", NPC)
	
	get_node(portrait).set_portrait(NPC.portrait_path, true)
	get_node(bio).set_bio(NPC.bio)

func save_changes():
	NPC.store_values()
	
	.save_changes()

func character_exists(id:String):
	var json_path = Character.json_paths[Character.STATS_PATHS.MODIFIED]
	var loaded_json = json_helper.load_json(json_path)
	
	for NPC in loaded_json.keys():
		if NPC == id:
			return true
	
	return false


func set_tab_id(new_id:String):
	.set_tab_id(new_id)
	
	NPC.id = tab_id
	
	if not tab_id == "":
		NPC.load_values()


func get_json_path():
	return Character.json_paths[Character.STATS_PATHS.MODIFIED]
