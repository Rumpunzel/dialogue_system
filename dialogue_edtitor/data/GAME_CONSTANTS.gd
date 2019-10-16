extends Node

# Values
var _PERCEPTION_VALUES = [ "politeness", "reliability", "selflessness", "sincerity", "loyalty" ]

# Value calculation constants. See 'calculate_perception_value' function in Character.gd
#warning-ignore:unused_class_variable
var _MAX_PERCEPTION_VALUE = 10
#warning-ignore:unused_class_variable
var _PERCEPTION_VALUE_SLOPE = 0.4
#warning-ignore:unused_class_variable
var _PECERPTION_VALUE_GROWTH_POINT = 5.0

# Print updates to console?
var verbose_mode = true
var log_history:Dictionary = { }


func get_perception_value_dictionary():
	var value_dic:Dictionary = { }
	
	for value in _PERCEPTION_VALUES:
		value_dic[value] = 0.0
	
	return value_dic

func print_to_console(print_string):
	print_string = str(print_string)
	
	var current_time = OS.get_system_time_msecs()
	log_history[current_time] = print_string
	
	if verbose_mode:
		print(print_string)
