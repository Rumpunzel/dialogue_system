extends Node
class_name Character

enum { POLITENESS, RELIABILITY, SELFLESSNESS, SINCERITY }

const VALUE_NAMES = [ "Politeness", "Reliability", "Selflessness", "Sincerity" ]

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

onready var percieved_starting_values:Array = [politeness, reliability, selflessness, sincerity]

# True == dialogue option passed || False == dialogue option failed
var dialogue_memories:Dictionary = { true: [], false: [] }
var big_deal_memories:Dictionary = { true: [], false: [] }


# Called when the node enters the scene tree for the first time.
func _ready():
	pass# Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func initiate_dialogue():
	get_node("/root/main/dialogue_text").start_dialogue(load_dialogue(dialogue_file_path))

func remember_response(new_memory:Dictionary):
	if new_memory.get("noteworthy", false):
		if new_memory.get("big_deal", false):
			big_deal_memories[new_memory.get("success", true)].append(new_memory)
		else:
			dialogue_memories[new_memory.get("success", true)].append(new_memory)

func calculate_perception_value(perception_values):
	var values = []
	
	for value in perception_values:
		# Philipp dark magic fuckery
		values.append(0.5 * (tanh(perception_value_slope * (value + perception_value_growth_point)) + tanh(perception_value_slope * (value - perception_value_growth_point))))
	
	return values


func load_dialogue(file_path):
	var file = File.new()
	
	assert file.file_exists(file_path)
	
	file.open(file_path, file.READ)
	
	var dialogue = parse_json(file.get_as_text())
	
	assert dialogue.size() > 0
	
	return dialogue
