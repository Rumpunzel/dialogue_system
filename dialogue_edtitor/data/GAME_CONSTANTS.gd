extends Node

# Values
var _PERCEPTION_VALUES = [ "politeness", "reliability", "selflessness", "sincerity" ] setget set_PERCEPTION_VALUES, get_PERCEPTION_VALUES

# Value calculation constants. See 'calculate_perception_value' function in Character.gd
#warning-ignore:unused_class_variable
var _MAX_PERCEPTION_VALUE = 10
#warning-ignore:unused_class_variable
var _MAX_APPROVAL_VALUE = 100
#warning-ignore:unused_class_variable
var _PERCEPTION_VALUE_SLOPE = 0.25
#warning-ignore:unused_class_variable
var _PECERPTION_VALUE_GROWTH_POINT = 10.0

# Print updates to console?
var verbose_mode = true
var log_history:Dictionary = { }

signal values_changed


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


func set_PERCEPTION_VALUES(new_values):
	_PERCEPTION_VALUES = new_values
	
	emit_signal("values_changed", _PERCEPTION_VALUES)

func get_PERCEPTION_VALUES() -> Array:
	return _PERCEPTION_VALUES
