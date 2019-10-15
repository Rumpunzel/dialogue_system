extends Node

# Values
const PERCEPTION_VALUES = [ "politeness", "reliability", "selflessness", "sincerity" ]

# Value calculation constants. See 'calculate_perception_value' function in Character.gd
const PERCEPTION_VALUE_SLOPE = 0.3
const PECERPTION_VALUE_GROWTH_POINT = 5.0

# Default dialogue tree name
const DEFAULT_TREE = "start"

# Dialogue hightlight color
const HIGHLIGHT_COLOR = "#830303"

# Dialogue option constants
const BACK_OPTION = "_back_option"
const CONTINUE_OPTION = "_continue_option"
const EXIT_OPTION = "_exit_option"
const CUSTOM_OPTION = "custom_option"


func get_perception_value_dictionary():
	var value_dic:Dictionary = { }
	
	for value in PERCEPTION_VALUES:
		value_dic[value] = 0.0
	
	return value_dic
