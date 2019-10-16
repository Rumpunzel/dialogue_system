extends Node
class_name Character

export(String, FILE, "*.json") var dialogue_file_path

#warning-ignore:unused_class_variable
export(int, -10, 10) var politeness_percieved
#warning-ignore:unused_class_variable
export(int, -10, 10) var reliability_percieved
#warning-ignore:unused_class_variable
export(int, -10, 10) var selflessness_percieved
#warning-ignore:unused_class_variable
export(int, -10, 10) var sincerity_percieved
#warning-ignore:unused_class_variable

onready var percieved_starting_values:Dictionary =  { GAME_CONSTANTS._PERCEPTION_VALUES[0]: politeness_percieved, GAME_CONSTANTS._PERCEPTION_VALUES[1]: reliability_percieved, GAME_CONSTANTS._PERCEPTION_VALUES[2]: selflessness_percieved, GAME_CONSTANTS._PERCEPTION_VALUES[3]: sincerity_percieved }

onready var memories:memories = $memories


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func initiate_dialogue(dialogue_node, specific_dilaogue = dialogue_file_path):
	dialogue_node.switch_dialogue(json_helper.load_json(specific_dilaogue))

func calculate_perception_value(perception_values):
	var values = { }
	
	for key in perception_values.keys():
		# Philipp dark magic fuckery
		values[key] = (0.5 * (tanh(GAME_CONSTANTS._PERCEPTION_VALUE_SLOPE * (perception_values[key] + GAME_CONSTANTS._PECERPTION_VALUE_GROWTH_POINT)) + tanh(GAME_CONSTANTS._PERCEPTION_VALUE_SLOPE * (perception_values[key] - GAME_CONSTANTS._PECERPTION_VALUE_GROWTH_POINT))))
	
	return values

func remember_response(new_memory:Dictionary):
	memories.remember_response(new_memory)

func remembers_dialogue_option(unique_id):
	return memories.remembers_dialogue_option(unique_id)
