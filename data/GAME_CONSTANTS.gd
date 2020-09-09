extends Node

enum CONSTANTS_PATHS { MODIFIED, DEFAULT }

const JSON_PATHS = { CONSTANTS_PATHS.MODIFIED: "res://data/GAME_CONSTANTS.json", CONSTANTS_PATHS.DEFAULT: "res://dialogue_engine/DEFAULT_GAME_CONSTANTS.json" }

var PERCEPTION_VALUES:Array setget set_PERCEPTION_VALUES, get_PERCEPTION_VALUES
var MAX_PERCEPTION_VALUE:float setget set_MAX_PERCEPTION_VALUE, get_MAX_PERCEPTION_VALUE
var MAX_APPROVAL_VALUE:float setget set_MAX_APPROVAL_VALUE, get_MAX_APPROVAL_VALUE
var PERCEPTION_VALUE_SLOPE:float setget set_PERCEPTION_VALUE_SLOPE, get_PERCEPTION_VALUE_SLOPE
var PERCERPTION_VALUE_GROWTH_POINT:float setget set_PERCERPTION_VALUE_GROWTH_POINT, get_PERCERPTION_VALUE_GROWTH_POINT

#var _most_recent_CONSTANTS:Dictionary

signal values_loaded
signal values_changed


func _enter_tree():
	load_values()
	
	connect("values_changed", self, "store_values")

#func _process(_delta):
#	if not CONSTANTS == _most_recent_CONSTANTS:
#		emit_signal("values_changed")
#
#		_most_recent_CONSTANTS = CONSTANTS


func calculate_growth_point():
	pass

func load_values(path:String = JSON_PATHS[CONSTANTS_PATHS.MODIFIED]):
	var loaded_json = JSONHelper.load_json(path)
	
	if loaded_json == null:
		loaded_json = JSONHelper.load_json(JSON_PATHS[CONSTANTS_PATHS.DEFAULT])
	
	for key in loaded_json.keys():
		set(key, loaded_json[key])
	
	emit_signal("values_loaded")
	emit_signal("values_changed")

func store_values():
	JSONHelper.save_json(get_constants(), JSON_PATHS[CONSTANTS_PATHS.MODIFIED])

func reset_values_to_default():
	load_values(JSON_PATHS[CONSTANTS_PATHS.DEFAULT])


func set_PERCEPTION_VALUES(new_value:Array):
	PERCEPTION_VALUES = new_value
	emit_signal("values_changed")

func set_MAX_PERCEPTION_VALUE(new_value:float):
	MAX_PERCEPTION_VALUE = new_value
	emit_signal("values_changed")

func set_MAX_APPROVAL_VALUE(new_value:float):
	MAX_APPROVAL_VALUE = new_value
	emit_signal("values_changed")

func set_PERCEPTION_VALUE_SLOPE(new_value:float):
	PERCEPTION_VALUE_SLOPE = new_value
	emit_signal("values_changed")

func set_PERCERPTION_VALUE_GROWTH_POINT(new_value:float):
	PERCERPTION_VALUE_GROWTH_POINT = new_value
	emit_signal("values_changed")


func get_constants() -> Dictionary:
	var dic:Dictionary
	
	dic = { "PERCEPTION_VALUES": PERCEPTION_VALUES,
			"MAX_PERCEPTION_VALUE": MAX_PERCEPTION_VALUE,
			"MAX_APPROVAL_VALUE": MAX_APPROVAL_VALUE,
			"PERCEPTION_VALUE_SLOPE": PERCEPTION_VALUE_SLOPE,
			"PERCERPTION_VALUE_GROWTH_POINT": PERCERPTION_VALUE_GROWTH_POINT }
	
	return dic

func get_PERCEPTION_VALUES() -> Array:
	return PERCEPTION_VALUES

func get_MAX_PERCEPTION_VALUE() -> float:
	return MAX_PERCEPTION_VALUE

func get_MAX_APPROVAL_VALUE() -> float:
	return MAX_APPROVAL_VALUE

func get_PERCEPTION_VALUE_SLOPE() -> float:
	return PERCEPTION_VALUE_SLOPE

func get_PERCERPTION_VALUE_GROWTH_POINT() -> float:
	return PERCERPTION_VALUE_GROWTH_POINT
