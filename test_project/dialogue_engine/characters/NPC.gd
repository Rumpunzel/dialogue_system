extends Character
class_name NPC

enum { _PERCEPTION_VALUES, APPROVAL_MODIFIER }

#warning-ignore:unused_class_variable
export(int, -10, 10) var politeness_preferred
#warning-ignore:unused_class_variable
export(int, -10, 10) var reliability_preferred
#warning-ignore:unused_class_variable
export(int, -10, 10) var selflessness_preferred
#warning-ignore:unused_class_variable
export(int, -10, 10) var sincerity_preferred
#warning-ignore:unused_class_variable

onready var personal_values:Dictionary = { GAME_CONSTANTS._PERCEPTION_VALUES[0]: politeness_preferred, GAME_CONSTANTS._PERCEPTION_VALUES[1]: reliability_preferred, GAME_CONSTANTS._PERCEPTION_VALUES[2]: selflessness_preferred, GAME_CONSTANTS._PERCEPTION_VALUES[3]: sincerity_preferred }

var character_perceptions:Dictionary


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func remember_response(new_memory:Dictionary):
	.remember_response(new_memory)
	modify_perception(new_memory["speaker"], new_memory["success"],  new_memory["value_changes"],  new_memory["approval_change"])

func modify_perception(target:Character, option_success, value_changes, approval_change):
	character_perceptions[target] = { _PERCEPTION_VALUES: character_perceptions.get(target, [target.percieved_starting_values])[_PERCEPTION_VALUES], APPROVAL_MODIFIER: character_perceptions.get(target, [0, 0])[APPROVAL_MODIFIER] }
	
	character_perceptions[target][_PERCEPTION_VALUES] = math_helper.vector_add_dictionaries([character_perceptions[target][_PERCEPTION_VALUES], value_changes])
	
	if option_success:
		character_perceptions[target][APPROVAL_MODIFIER] += approval_change
		
		if not character_perceptions[target][APPROVAL_MODIFIER] == 0:
			GAME_CONSTANTS.print_to_console("%s now has a %0.2f%% Approval Bonus towards %s" % [name, character_perceptions[target][APPROVAL_MODIFIER], target.name])
	
	GAME_CONSTANTS.print_to_console("New Values for %s towards %s: %s, %s" % [name, target.name, character_perceptions[target][_PERCEPTION_VALUES], calculate_perception_value(character_perceptions[target][_PERCEPTION_VALUES])])
	GAME_CONSTANTS.print_to_console("Approval Rating of %s towards %s is now: %0.2f of a possible %0.2f" % [name, target.name, calculate_approval_rating(target, true), maximum_possible_approval_rating()])

func calculate_approval_rating(target:Character, print_update = false):
	var approval_rating = 0
	var update_string = "Approval Changes: "
	
	if not character_perceptions.get(target, null) == null:
		var perception_values = calculate_perception_value(character_perceptions[target][_PERCEPTION_VALUES])
		
		for value in personal_values.keys():
			var approval_change = perception_values[value] * personal_values[value]
			
			if not approval_change == 0:
				update_string += "%s%0.2f from %s, " % ["+" if approval_change >= 0 else "", approval_change, value.capitalize()]
			approval_rating += approval_change
		
		approval_rating += character_perceptions[target][APPROVAL_MODIFIER]
	
	if print_update:
		GAME_CONSTANTS.print_to_console(update_string.substr(0, update_string.length() - 2))
	
	return approval_rating

func maximum_possible_approval_rating():
	var poss_max =  0
	
	for value in personal_values.values():
		poss_max += abs(value)
	
	return poss_max
