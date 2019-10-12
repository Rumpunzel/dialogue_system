extends Character
class_name NPC

enum { PERCEPTION_VALUES, APPROVAL_MODIFIER }

onready var personal_values = [politeness, reliability, selflessness, sincerity]

var character_perceptions:Dictionary


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func remember_response(new_memory):
	.remember_response(new_memory)
	modify_perception(new_memory["speaker"], new_memory["success"],  new_memory["value_changes"],  new_memory["approval_change"])
	print(dialogue_memories)
	print(big_deal_memories)

func modify_perception(target:Character, option_success, value_changes, approval_change):
	character_perceptions[target] = { PERCEPTION_VALUES: character_perceptions.get(target, [target.percieved_starting_values])[PERCEPTION_VALUES], APPROVAL_MODIFIER: character_perceptions.get(target, [0, 0])[APPROVAL_MODIFIER] }
	
	character_perceptions[target][PERCEPTION_VALUES] = math_helper.vector_add_arrays([character_perceptions[target][PERCEPTION_VALUES], value_changes])
	
	if option_success:
		character_perceptions[target][APPROVAL_MODIFIER] += approval_change
		
		if not character_perceptions[target][APPROVAL_MODIFIER] == 0:
			print("%s now has a %0.2f%% Approval Bonus towards %s" % [name, character_perceptions[target][APPROVAL_MODIFIER] * 100, target.name])
	
	print("New Values for %s towards %s: %s, %s" % [name, target.name, character_perceptions[target][PERCEPTION_VALUES], calculate_perception_value(character_perceptions[target][PERCEPTION_VALUES])])
	print("Approval Rating of %s towards %s is now: %0.2f%% of a possible %0.2f%%" % [name, target.name, calculate_approval_rating(target, true) * 100, maximum_possible_approval_rating()])

func calculate_approval_rating(target:Character, print_update = false):
	var approval_rating = 0
	var update_string = "Approval Changes: "
	
	if not character_perceptions.get(target, null) == null:
		var perception_values = calculate_perception_value(character_perceptions[target][PERCEPTION_VALUES])
		
		for i in personal_values.size():
			var approval_change = perception_values[i] * personal_values[i]
			
			if not approval_change == 0:
				update_string += ("+" if approval_change >= 0 else "") + str(approval_change) + " from " + VALUE_NAMES[i] + ", "
			approval_rating += approval_change
		
		approval_rating += character_perceptions[target][APPROVAL_MODIFIER]
	
	if print_update:
		print(update_string.substr(0, update_string.length() - 2))
	
	return approval_rating

func maximum_possible_approval_rating():
	var poss_max =  0
	
	for value in personal_values:
		poss_max += abs(value)
	
	return poss_max * 100
