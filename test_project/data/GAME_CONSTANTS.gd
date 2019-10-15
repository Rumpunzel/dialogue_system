extends Node

# Values
const PERCEPTION_VALUES = [ "politeness", "reliability", "selflessness", "sincerity" ]

# Value calculation constants. See 'calculate_perception_value' function in Character.gd
const PERCEPTION_VALUE_SLOPE = 0.3
const PECERPTION_VALUE_GROWTH_POINT = 5.0


func get_perception_value_dictionary():
	var value_dic:Dictionary = { }
	
	for value in PERCEPTION_VALUES:
		value_dic[value] = 0.0
	
	return value_dic
