extends Node

const json_path = "res://data/GAME_CONSTANTS.json"

# Perception Values
var _PERCEPTION_VALUES:Array setget set_PERCEPTION_VALUES, get_PERCEPTION_VALUES

# Value calculation constants. See 'calculate_perception_value' function in Character.gd
var _MAX_PERCEPTION_VALUE:int setget set_MAX_PERCEPTION_VALUE, get_MAX_PERCEPTION_VALUE
var _MAX_APPROVAL_VALUE:int setget set_MAX_APPROVAL_VALUE, get_MAX_APPROVAL_VALUE
var _PERCEPTION_VALUE_SLOPE:float setget set_PERCEPTION_VALUE_SLOPE, get_PERCEPTION_VALUE_SLOPE
var _PECERPTION_VALUE_GROWTH_POINT:float setget set_PECERPTION_VALUE_GROWTH_POINT, get_PECERPTION_VALUE_GROWTH_POINT

var constants_json:Dictionary

# Print updates to console?
var verbose_mode = true
var log_history:Dictionary = { }

signal values_changed


func _enter_tree():
	constants_json = json_helper.load_json(json_path)
	
	for key in constants_json.keys():
		set(key, constants_json[key])
	
	connect("values_changed", self, "store_values")


func store_values():
	json_helper.save_json(constants_json, json_path)

func print_to_console(print_string):
	print_string = str(print_string)
	
	var current_time = OS.get_system_time_msecs()
	log_history[current_time] = print_string
	
	if verbose_mode:
		print(print_string)


func set_PERCEPTION_VALUES(new_values:Array):
	_PERCEPTION_VALUES = new_values
	constants_json["_PERCEPTION_VALUES"] = new_values
	emit_signal("values_changed")

func set_MAX_PERCEPTION_VALUE(new_value):
	_MAX_PERCEPTION_VALUE = int(new_value)
	constants_json["_MAX_PERCEPTION_VALUE"] = new_value
	emit_signal("values_changed")

func set_MAX_APPROVAL_VALUE(new_value):
	_MAX_APPROVAL_VALUE = int(new_value)
	constants_json["_MAX_APPROVAL_VALUE"] = new_value
	emit_signal("values_changed")

func set_PERCEPTION_VALUE_SLOPE(new_value):
	_PERCEPTION_VALUE_SLOPE = float(new_value)
	constants_json["_PERCEPTION_VALUE_SLOPE"] = new_value
	emit_signal("values_changed")

func set_PECERPTION_VALUE_GROWTH_POINT(new_value):
	_PECERPTION_VALUE_GROWTH_POINT = float(new_value)
	constants_json["_PECERPTION_VALUE_GROWTH_POINT"] = new_value
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
