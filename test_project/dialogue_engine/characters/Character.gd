extends Node
class_name Character

# For easier dictionary access
enum STATS_PATHS { MODIFIED, DEFAULT }
# The default stats of a character should there be no .char file specified
const DEFAULT_CHARACTER_STATS:String = "res://dialogue_engine/characters/DEFAULT_CHARACTER_STATS.json"

const json_paths:Dictionary = { STATS_PATHS.MODIFIED: CONSTANTS.CHARACTERS_JSON, STATS_PATHS.DEFAULT: DEFAULT_CHARACTER_STATS }

# The path to the .char file of the character
export(String, FILE, "*.char") var json_path = "" setget set_json_path, get_json_path
# The path to the .convo file of the (default) conversation for this character
export(String, FILE, "*.convo") var conversation_path setget set_conversation_path, get_conversation_path


onready var id:String = name setget set_id, get_id
onready var memories:memories = $memories
# Default perception characters will have of this character without ever metting them (basically reputations)
var percieved_starting_values:Dictionary setget set_percieved_starting_values, get_percieved_starting_values

var portrait:Texture setget set_portrait, get_portrait
var portrait_path:String setget set_portrait_path, get_portrait_path
# Bio for the character editor / index
var bio:String setget set_bio, get_bio
# The contents of the .char file this node will save / load
var character_json:Dictionary


# Called when the node enters the scene tree for the first time.
func _ready():
	# Setup the character
	if get_tree().root.has_node("CHARACTERS"):
		var character_manager = get_node("/root/CHARACTERS")
		
		if json_path == "":
			json_path = character_manager.character_jsons.get(name, "")
		
		load_values()
		memories.load_values(id)
		
		# Register at the CHARACTERS singleton if in a game scene
		# Maps the character id to this specific node
		character_manager.register_character(id, self)
	else:
		CONSTANTS.print_to_console("%s instanced outside of character manager!" % [name])

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _exit_tree():
	# Unregister character from the CHARACTERS manager when leaving scene
	if get_tree().root.has_node("CHARACTERS"):
		get_node("/root/CHARACTERS").unregister_character(id)


# Used to initiate dialogue with this character
# The dialogue_window is currently handled by getting a relative path (has to be improved to make more flexible)
func initiate_dialogue(specific_dilaogue = null):
	# Load the default or a specified dialogue
	var loaded_json = json_helper.load_json(conversation_path if specific_dilaogue == null else specific_dilaogue)
	# Hand dialogue over to the dialogue window which will handle the rest of the dialogue
	if not loaded_json == null:
		get_node("%s/%s" % ["../..", CONSTANTS.DIALOGUE_WINDOW_PATH]).switch_dialogue(loaded_json)

# Calculates this characters personal values with the perception values they have of another character
# Takes a dictionary as paramter to enable this function to be used out of context of a game (e.g. in an editor)
func calculate_perception_value(perception_values:Dictionary) -> Dictionary:
	var values = { }
	# See the readme in the dialogue_engine on the github on how exactly this works
	for key in perception_values.keys():
		var slope = GAME_CONSTANTS.PERCEPTION_VALUE_SLOPE
		var growth_point = GAME_CONSTANTS.PERCERPTION_VALUE_GROWTH_POINT
		# Philipp dark magic fuckery
		values[key] = tanh(slope * (perception_values[key] + growth_point)) + tanh(slope * (perception_values[key] - growth_point))
	
	return values

# For loading characters stats and values
func load_values():
	var loaded_json = json_helper.load_json(json_path)
	
	character_json = loaded_json if not loaded_json == null else json_helper.load_json(json_paths[STATS_PATHS.DEFAULT])
	
	for key in character_json.keys():
		set(key, character_json[key])

# For storing value changes for this character
func store_values():
	for key in character_json.keys():
		var property = get(key)
		character_json[key] = property if not property == null else character_json[key]
	
	json_helper.save_json(character_json, json_path)

# Saving a response said to this character to disk
func remember_response(new_memory:Dictionary):
	memories.remember_response(new_memory)
	store_values()

# Checking if a character remembers a specific response
func remembers_dialogue_option(unique_id):
	return memories.remembers_dialogue_option(unique_id)



func set_bio(new_bio:String):
	bio = new_bio
	character_json["bio"] = bio

func set_conversation_path(new_path:String):
	conversation_path = new_path

func set_id(new_id:String):
	id = new_id
	
	if not id == "":
		name = id

func set_json_path(new_path:String):
	json_path = new_path

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

func get_conversation_path() -> String:
	return conversation_path

func get_id() -> String:
	return id

func get_json_path() -> String:
	return json_path

func get_percieved_starting_values() -> Dictionary:
	return percieved_starting_values

func get_portrait() -> Texture:
	return portrait

func get_portrait_path() -> String:
	return portrait_path
