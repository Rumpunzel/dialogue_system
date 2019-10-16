extends Node

# Print updates to console?
const VERBOSE = true

# Values
const PERCEPTION_VALUES = [ "politeness", "reliability", "selflessness", "sincerity" ]

# Value calculation constants. See 'calculate_perception_value' function in Character.gd
const MAX_PERCEPTION_VALUE = 10
const PERCEPTION_VALUE_SLOPE = 0.4
const PECERPTION_VALUE_GROWTH_POINT = 5.0

var log_history:Dictionary = { }


func get_perception_value_dictionary():
	var value_dic:Dictionary = { }
	
	for value in PERCEPTION_VALUES:
		value_dic[value] = 0.0
	
	return value_dic

func print_to_console(print_string):
	print_string = str(print_string)
	
	var current_time = OS.get_system_time_msecs()
	log_history[current_time] = print_string
	
	if VERBOSE:
		print(print_string)
