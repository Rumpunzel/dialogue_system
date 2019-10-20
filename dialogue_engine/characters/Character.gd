extends Node
class_name Character

enum STATS_PATHS { MODIFIED, DEFAULT }

const DEFAULT_CHARACTER_STATS:String = "res://dialogue_engine/characters/DEFAULT_CHARACTER_STATS.json"
const CHARACTERS_JSON:String = "res://data/characters/characters.json"
const DIALOGUE_PATHS:String = "data/dialogues/default.json"

const json_paths:Dictionary = { STATS_PATHS.MODIFIED: CHARACTERS_JSON, STATS_PATHS.DEFAULT: DEFAULT_CHARACTER_STATS }

onready var id:String = name setget set_id, get_id
onready var memories:memories = $memories

var percieved_starting_values:Dictionary

var character_json:Dictionary


# Called when the node enters the scene tree for the first time.
func _ready():
	load_values()
	#memories.load_values(id)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func initiate_dialogue(dialogue_node, specific_dilaogue = DIALOGUE_PATHS):
	var loaded_json = json_helper.load_json(specific_dilaogue)
	if not loaded_json == null:
		dialogue_node.switch_dialogue(loaded_json)

func calculate_perception_value(perception_values:Dictionary):
	var values = { }
	
	for key in perception_values.keys():
		var slope = GC.CONSTANTS[GC.PERCEPTION_VALUE_SLOPE]
		var growth_point = GC.CONSTANTS[GC.PERCERPTION_VALUE_GROWTH_POINT]
		# Philipp dark magic fuckery
		values[key] = tanh(slope * (perception_values[key] + growth_point)) + tanh(slope * (perception_values[key] - growth_point))
	
	return values

func load_values():
	var loaded_json = json_helper.load_json(json_paths[STATS_PATHS.MODIFIED])
	
	loaded_json = loaded_json.get(id) if not loaded_json == null else null
	character_json = loaded_json if not loaded_json == null else json_helper.load_json(json_paths[STATS_PATHS.DEFAULT])
	
	for key in character_json.keys():
		set(key, character_json[key])

func store_values():
	for key in character_json.keys():
		character_json[key] = get(key)
	
	var loaded_json = json_helper.load_json(json_paths[STATS_PATHS.MODIFIED])
	loaded_json[id] = character_json
	
	json_helper.save_json(loaded_json, json_paths[STATS_PATHS.MODIFIED])

func remember_response(new_memory:Dictionary):
	memories.remember_response(new_memory)
	store_values()

func remembers_dialogue_option(unique_id):
	return memories.remembers_dialogue_option(unique_id)


func set_id(new_id:String):
	id = new_id
	
	if not id == "":
		name = id


func get_id() -> String:
	return id
