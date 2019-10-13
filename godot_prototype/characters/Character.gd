extends Node
class_name Character

#enum { POLITENESS, RELIABILITY, SELFLESSNESS, SINCERITY }

const POLITENESS = "politeness"
const RELIABILITY = "reliability"
const SELFLESSNESS = "selflessness"
const SINCERITY = "sincerity"

const PASSED = "passed"
const FAILED = "failed"
const BIG_DEAL = "big_deal"
const NORMAL = "normal"

const SUCCESS_MAP = { true: PASSED, false: FAILED }
const BIG_DEAL_MAP = { true: BIG_DEAL, false: NORMAL }

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

onready var dialogue_memories:Dictionary = { BIG_DEAL: { PASSED: [ ], FAILED: [ ] }, NORMAL: { PASSED: [ ], FAILED: [ ] } }


# Called when the node enters the scene tree for the first time.
func _ready():
	pass# Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func initiate_dialogue():
	get_node("/root/main/dialogue_text").switch_dialogue(load_dialogue(dialogue_file_path))

func remember_response(new_memory:Dictionary):
	if new_memory.get("noteworthy", false):
		dialogue_memories[ BIG_DEAL_MAP[ new_memory.get("big_deal", false) ] ][ SUCCESS_MAP[ new_memory.get("success", true) ] ].append(new_memory)

func calculate_perception_value(perception_values):
	var values = { }
	
	for key in perception_values.keys():
		# Philipp dark magic fuckery
		values[key] = (0.5 * (tanh(perception_value_slope * (perception_values[key] + perception_value_growth_point)) + tanh(perception_value_slope * (perception_values[key] - perception_value_growth_point))))
	
	return values


func load_dialogue(file_path):
	var file = File.new()
	
	assert file.file_exists(file_path)
	
	file.open(file_path, file.READ)
	
	var dialogue = parse_json(file.get_as_text())
	
	assert dialogue.size() > 0
	
	return dialogue
