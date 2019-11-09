extends VBoxContainer
class_name character_editor

export(NodePath) var save_button
export(NodePath) var close_button
export(NodePath) var delete_button

onready var NPC:NPC = $NPC

var character_id:String setget set_character_id, get_character_id
var old_id:String

signal current_NPC


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(save_button).connect("pressed", self, "save_changes")
	get_node(close_button).connect("pressed", self, "close_tab")
	get_node(delete_button).connect("pressed", self, "delete_character")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func setup(id:String):
	set_character_id(id)
	
	emit_signal("current_NPC", NPC)
	
	old_id = id

func save_changes():
	NPC.store_values()
	
	if not old_id == character_id:
		delete_character(old_id)
		old_id = character_id

func close_tab():
	queue_free()

func delete_character(id = NPC.id):
	var json_path = Character.json_paths[Character.STATS_PATHS.MODIFIED]
	
	var loaded_json = json_helper.load_json(json_path)
	loaded_json.erase(id)
	
	json_helper.save_json(loaded_json, json_path)
	
	if id == character_id:
		close_tab()

func character_exists(id:String):
	var json_path = Character.json_paths[Character.STATS_PATHS.MODIFIED]
	var loaded_json = json_helper.load_json(json_path)
	
	for NPC in loaded_json.keys():
		if NPC == id:
			return true
	
	return false


func set_character_id(new_id:String):
	character_id = new_id
	NPC.id = character_id
	
	if not character_id == "":
		name = character_id
		
		NPC.load_values()


func get_character_id() -> String:
	return character_id
