extends Node

# Values
var _PERCEPTION_VALUES:Array = [ "politeness", "reliability", "selflessness", "sincerity" ] setget set_PERCEPTION_VALUES, get_PERCEPTION_VALUES

# Value calculation constants. See 'calculate_perception_value' function in Character.gd
#warning-ignore:unused_class_variable
var _MAX_PERCEPTION_VALUE:int = 10 setget set_MAX_PERCEPTION_VALUE, get_MAX_PERCEPTION_VALUE
#warning-ignore:unused_class_variable
var _MAX_APPROVAL_VALUE:int = 100 setget set_MAX_APPROVAL_VALUE, get_MAX_APPROVAL_VALUE
#warning-ignore:unused_class_variable
var _PERCEPTION_VALUE_SLOPE:float = 0.15 setget set_PERCEPTION_VALUE_SLOPE, get_PERCEPTION_VALUE_SLOPE
#warning-ignore:unused_class_variable
var _PECERPTION_VALUE_GROWTH_POINT:float = 10 setget set_PECERPTION_VALUE_GROWTH_POINT, get_PECERPTION_VALUE_GROWTH_POINT

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


func set_PERCEPTION_VALUES(new_values:Array):
	_PERCEPTION_VALUES = new_values
	emit_signal("values_changed")

func set_MAX_PERCEPTION_VALUE(new_value):
	_MAX_PERCEPTION_VALUE = int(new_value)
	emit_signal("values_changed")

func set_MAX_APPROVAL_VALUE(new_value):
	_MAX_APPROVAL_VALUE = int(new_value)
	emit_signal("values_changed")

func set_PERCEPTION_VALUE_SLOPE(new_value):
	_PERCEPTION_VALUE_SLOPE = float(new_value)
	emit_signal("values_changed")

func set_PECERPTION_VALUE_GROWTH_POINT(new_value):
	_PECERPTION_VALUE_GROWTH_POINT = float(new_value)
	emit_signal("values_changed")


func get_PERCEPTION_VALUES() -> Array:
	return _PERCEPTION_VALUES

func get_MAX_PERCEPTION_VALUE() -> int:
	return _MAX_PERCEPTION_VALUE

func get_MAX_APPROVAL_VALUE() -> int:
	return _MAX_APPROVAL_VALUE

func get_PERCEPTION_VALUE_SLOPE() -> float:
	return _PERCEPTION_VALUE_SLOPE

func get_PECERPTION_VALUE_GROWTH_POINT() -> float:
	return _PECERPTION_VALUE_GROWTH_POINT
