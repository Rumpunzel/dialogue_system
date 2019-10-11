extends Character
class_name NPC

onready var personal_values = [politeness, reliability, selflessness, sincerity]

var character_perceptions:Dictionary


# Called when the node enters the scene tree for the first time.
#func _ready():
# pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func remember_response(target:Character, dialogue_tree_root, option_success, value_changes, big_deal):
	.remember_response(target, dialogue_tree_root, option_success, value_changes, big_deal)
	modify_perception(target, value_changes)

func modify_perception(target:Character, value_changes):
	character_perceptions[target] = character_perceptions.get(target, target.percieved_starting_values)
	character_perceptions[target] = math_helper.vector_add_arrays([character_perceptions[target], value_changes])
	
	print("New Values for %s towards %s: %s, %s" % [name, target.name, character_perceptions[target], calculate_perception_value(character_perceptions[target])])
	print("Approval Rating of %s towards %s is now: %f%% of a possible %f%%" % [name, target.name, calculate_approval_rating(target, true) * 100, maximum_possible_approval_rating()])
	

func calculate_approval_rating(target:Character, print_update = false):
	var approval_rating = 0
	var update_string = "Approval Changes: "
	
	if not character_perceptions.get(target, null) == null:
		var perception_values = calculate_perception_value(character_perceptions[target])
		
		for i in personal_values.size():
			var approval_change = perception_values[i] * personal_values[i]
			
			if not approval_change == 0:
				update_string += ("+" if approval_change >= 0 else "") + str(approval_change) + " from " + VALUE_NAMES[i] + ", "
			approval_rating += approval_change
	
	if print_update:
		print(update_string.substr(0, update_string.length() - 2))
	
	return approval_rating

func maximum_possible_approval_rating():
	var poss_max =  0
	
	for value in personal_values:
		poss_max += abs(value)
	
	return poss_max * 100
