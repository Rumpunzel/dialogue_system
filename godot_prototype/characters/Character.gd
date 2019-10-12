extends Node
class_name Character

enum { POLITENESS, RELIABILITY, SELFLESSNESS, SINCERITY }

const VALUE_NAMES = [ "Politeness", "Reliability", "Selflessness", "Sincerity" ]

const perception_value_slope = 0.5
const perception_value_growth_point = 5.0

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

var dialogue_memories:Array = []
var big_deal_memories:Array = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func remember_response(target:Character, dialogue_tree_root, option_success, value_changes, approval_change, big_deal):
	var memory = [target, dialogue_tree_root, option_success, value_changes, approval_change]
	
	if big_deal:
		big_deal_memories.append(memory)
	else:
		dialogue_memories.append(memory)

func calculate_perception_value(perception_values):
	var values = []
	
	for value in perception_values:
		# Philipp dark magic fuckery
		values.append(0.5 * (tanh(perception_value_slope * (value + perception_value_growth_point)) + tanh(perception_value_slope * (value - perception_value_growth_point))))
	
	return values
