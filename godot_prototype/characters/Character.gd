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
export(float, -1, 1) var politeness
#warning-ignore:unused_class_variable
export(float, -1, 1) var reliability
#warning-ignore:unused_class_variable
export(float, -1, 1) var selflessness
#warning-ignore:unused_class_variable
export(float, -1, 1) var sincerity
#warning-ignore:unused_class_variable

onready var percieved_starting_values:Dictionary =  { POLITENESS: politeness, RELIABILITY: reliability, SELFLESSNESS: selflessness, SINCERITY: sincerity }

onready var memories:memories = $memories


# Called when the node enters the scene tree for the first time.
func _ready():
	pass# Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func initiate_dialogue(dialogue_node, specific_dilaogue = dialogue_file_path):
	dialogue_node.switch_dialogue(load_dialogue(specific_dilaogue))

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


func load_dialogue(file_path):
	var file = File.new()
	
	assert file.file_exists(file_path)
	
	file.open(file_path, file.READ)
	
	var dialogue = parse_json(file.get_as_text())
	
	assert dialogue.size() > 0
	
	return dialogue
