extends Node
class_name Character

enum STATS_PATHS { MODIFIED, DEFAULT }

const DEFAULT_CHARACTER_STATS:String = "res://dialogue_engine/characters/DEFAULT_CHARACTER_STATS.json"
const CHARACTERS_JSON:String = "res://data/characters/characters.json"
const DIALOGUE_PATHS:String = "data/dialogues/default.json"

const json_paths:Dictionary = { STATS_PATHS.MODIFIED: CHARACTERS_JSON, STATS_PATHS.DEFAULT: DEFAULT_CHARACTER_STATS }

onready var id:String = name setget set_id, get_id
onready var memories:memories = $memories

onready var CHARACTERS = CONSTANTS.get_CHARACTERS()

var percieved_starting_values:Dictionary setget set_percieved_starting_values, get_percieved_starting_values

var portrait:Texture setget set_portrait, get_portrait
var portrait_path:String setget set_portrait_path, get_portrait_path

var bio:String setget set_bio, get_bio

var character_json:Dictionary


# Called when the node enters the scene tree for the first time.
func _ready():
	load_values()
	#memories.load_values(id)
	
	if not CHARACTERS == null:
		CHARACTERS.register_character(id, self)
	else:
		CONSTANTS.print_to_console("%s instanced outside of character manager!" % [name])

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
		var slope = GAME_CONSTANTS.PERCEPTION_VALUE_SLOPE
		var growth_point = GAME_CONSTANTS.PERCERPTION_VALUE_GROWTH_POINT
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


func set_bio(new_bio:String):
	bio = new_bio
	character_json["bio"] = bio

func set_id(new_id:String):
	id = new_id
	
	if not id == "":
		name = id

func set_percieved_starting_values(new_values:Dictionary):
	percieved_starting_values = new_values
	character_json["percieved_starting_values"] = percieved_starting_values

func set_portrait(new_portrait:Texture):
	portrait = new_portrait

func set_portrait_path(new_path:String):
	portrait_path = new_path
	portrait = load(portrait_path)
	character_json["portrait_path"] = portrait_path


func get_bio() -> String:
	return bio

func get_id() -> String:
	return id

func get_percieved_starting_values() -> Dictionary:
	return percieved_starting_values

func get_portrait() -> Texture:
	return portrait

func get_portrait_path() -> String:
	return portrait_path
