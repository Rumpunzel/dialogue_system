extends VBoxContainer
class_name character_editor

export(NodePath) var NPC_node

export(NodePath) var save_button
export(NodePath) var close_button
export(NodePath) var delete_button

onready var NPC:NPC = get_node(NPC_node)

var character_id:String setget set_character_id, get_character_id


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(save_button).connect("pressed", self, "save_changes")
	get_node(close_button).connect("pressed", self, "close_tab")
	get_node(delete_button).connect("pressed", self, "delete_character")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func save_changes():
	NPC.store_values()

func close_tab():
	queue_free()

func delete_character():
	var json_path = Character.json_paths[Character.STATS_PATHS.MODIFIED]
	
	var loaded_json = json_helper.load_json(json_path)
	loaded_json.erase(NPC.id)
	
	json_helper.save_json(loaded_json, json_path)
	
	close_tab()


func set_character_id(new_id:String):
	character_id = new_id
	name = character_id


func get_character_id() -> String:
	return character_id
