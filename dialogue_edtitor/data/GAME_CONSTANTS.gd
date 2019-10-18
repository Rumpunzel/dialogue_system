extends Node

enum CONSTANTS_PATHS { MODIFIED, DEFAULT }

const PERCEPTION_VALUES = "PERCEPTION_VALUES"
const MAX_PERCEPTION_VALUE = "MAX_PERCEPTION_VALUE"
const MAX_APPROVAL_VALUE = "MAX_APPROVAL_VALUE"
const PERCEPTION_VALUE_SLOPE = "PERCEPTION_VALUE_SLOPE"
const PECERPTION_VALUE_GROWTH_POINT = "PECERPTION_VALUE_GROWTH_POINT"

const JSON_PATHS = { CONSTANTS_PATHS.MODIFIED: "res://data/GAME_CONSTANTS.json", CONSTANTS_PATHS.DEFAULT: "res://dialogue_engine/DEFAULT_GAME_CONSTANTS.json" }

var CONSTANTS:Dictionary setget set_CONSTANTS, get_CONSTANTS

signal values_loaded
signal values_changed


func _enter_tree():
	load_values()
	
	connect("values_changed", self, "store_values")


func load_values():
	var loaded_json = json_helper.load_json(JSON_PATHS[CONSTANTS_PATHS.MODIFIED])
	CONSTANTS = loaded_json if not loaded_json == null else json_helper.load_json(JSON_PATHS[CONSTANTS_PATHS.DEFAULT])
	
	emit_signal("values_loaded")

func store_values():
	json_helper.save_json(CONSTANTS, JSON_PATHS[CONSTANTS_PATHS.MODIFIED])


func set_CONSTANTS(new_values:Dictionary):
	CONSTANTS[PERCEPTION_VALUES] = new_values
	emit_signal("values_changed")


func get_CONSTANTS() -> Dictionary:
	return CONSTANTS
