extends Node
class_name Character

#enum { POLITENESS, RELIABILITY, SELFLESSNESS, SINCERITY }

const POLITENESS = "politeness"
const RELIABILITY = "reliability"
const SELFLESSNESS = "selflessness"
const SINCERITY = "sincerity"

const perception_value_slope = 0.3
const perception_value_growth_point = 5.0

export(String, FILE, "*.json") var dialogue_file_path

#warning-ignore:unused_class_variable
export(float, -1, 1) var politeness_percieved
#warning-ignore:unused_class_variable
export(float, -1, 1) var reliability_percieved
#warning-ignore:unused_class_variable
export(float, -1, 1) var selflessness_percieved
#warning-ignore:unused_class_variable
export(float, -1, 1) var sincerity_percieved
#warning-ignore:unused_class_variable

onready var percieved_starting_values:Dictionary =  { POLITENESS: politeness_percieved, RELIABILITY: reliability_percieved, SELFLESSNESS: selflessness_percieved, SINCERITY: sincerity_percieved }

onready var memories:memories = $memories


# Called when the node enters the scene tree for the first time.
func _ready():
	pass# Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func initiate_dialogue(dialogue_node, specific_dilaogue = dialogue_file_path):
	dialogue_node.switch_dialogue(json_helper.load_json(specific_dilaogue))

func calculate_perception_value(perception_values):
	var values = { }
	
	for key in perception_values.keys():
		# Philipp dark magic fuckery
		values[key] = (0.5 * (tanh(perception_value_slope * (perception_values[key] + perception_value_growth_point)) + tanh(perception_value_slope * (perception_values[key] - perception_value_growth_point))))
	
	return values

func remember_response(new_memory:Dictionary):
	memories.remember_response(new_memory)

func remembers_dialogue_option(unique_id):
	return memories.remembers_dialogue_option(unique_id)
