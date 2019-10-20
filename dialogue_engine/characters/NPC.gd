extends Character
class_name NPC

const PERCEPTION_VALUES = "PERCEPTION_VALUES"
const APPROVAL_MODIFIER = "APPROVAL_MODIFIER"

var personal_values:Dictionary setget set_personal_values, get_personal_values
var character_perceptions:Dictionary  setget set_character_perceptions, get_character_perceptions

signal values_changed
signal perceptions_changed


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func remember_response(new_memory:Dictionary):
	.remember_response(new_memory)
	if not new_memory["approval_change"] == 0 or (not new_memory["value_changes"].values().empty() and (new_memory["value_changes"].values().max() > 0 or new_memory["value_changes"].values().min() < 0)):
		modify_perception(new_memory["speaker"], new_memory["success"],  new_memory["value_changes"], new_memory["approval_change"])

func modify_perception(target:Character, option_success, value_changes, approval_change):
	character_perceptions[target.id] = { PERCEPTION_VALUES: character_perceptions.get(target.id, { PERCEPTION_VALUES: target.percieved_starting_values })[PERCEPTION_VALUES], APPROVAL_MODIFIER: character_perceptions.get(target.id, { APPROVAL_MODIFIER: 0 })[APPROVAL_MODIFIER] }
	
	character_perceptions[target.id][PERCEPTION_VALUES] = math_helper.vector_add_dictionaries([character_perceptions[target.id][PERCEPTION_VALUES], value_changes])
	
	if option_success:
		character_perceptions[target.id][APPROVAL_MODIFIER] += approval_change
		
		if not character_perceptions[target.id][APPROVAL_MODIFIER] == 0:
			CONSTANTS.print_to_console("%s now has a %0.2f point Approval Bonus towards %s" % [name, character_perceptions[target.id][APPROVAL_MODIFIER], target.id])
	
	CONSTANTS.print_to_console("New Values for %s towards %s: %s" % [name, target.id, character_perceptions[target.id][PERCEPTION_VALUES]])
	CONSTANTS.print_to_console("Approval Rating of %s towards %s is now: %0.2f of a possible %0.2f%s" % [name, target.id, calculate_approval_rating(target, true), maximum_possible_approval_rating() + character_perceptions[target.id][APPROVAL_MODIFIER], (" (%0.2f base + %0.2f bonus)" % [maximum_possible_approval_rating(), character_perceptions[target.id][APPROVAL_MODIFIER]] if not character_perceptions[target.id][APPROVAL_MODIFIER] == 0 else "")])
	
	emit_signal("perceptions_changed", character_perceptions, target.id)

func calculate_approval_rating(target:Character, print_update = false):
	var approval_rating = 0
	var update_string = ""
	
	if not character_perceptions.get(target.id) == null:
		var perception_values = character_perceptions[target.id][PERCEPTION_VALUES]
		var calculated_personal_values = calculate_perception_value(personal_values)
		
		for value in perception_values.keys():
			var approval_change = ((perception_values[value] / GC.CONSTANTS[GC.MAX_PERCEPTION_VALUE]) * calculated_personal_values[value]) * (1.0 / GC.CONSTANTS[GC.PERCEPTION_VALUES].size()) * GC.CONSTANTS[GC.MAX_APPROVAL_VALUE]
			
			if not approval_change == 0:
				update_string += "%s%0.2f from %s, " % ["+" if approval_change >= 0 else "", approval_change, value.capitalize()]
			approval_rating += approval_change
		
		approval_rating += character_perceptions[target.id][APPROVAL_MODIFIER]
	
	if print_update and update_string.length() > 0:
		CONSTANTS.print_to_console("Approval Changes: " + update_string.substr(0, update_string.length() - 2))
	
	return approval_rating

func maximum_possible_approval_rating(values:Dictionary = personal_values):
	values = calculate_perception_value(values)
	var poss_max =  0
	
	for value in values.values():
		poss_max += abs(value)
	
	return stepify(GC.CONSTANTS[GC.MAX_PERCEPTION_VALUE] * ((poss_max * (float(GC.CONSTANTS[GC.MAX_APPROVAL_VALUE]) / float(GC.CONSTANTS[GC.MAX_PERCEPTION_VALUE]))) / float(GC.CONSTANTS[GC.PERCEPTION_VALUES].size())), 0.01)

func store_values():
	character_json["personal_values"] = personal_values
	character_json["character_perceptions"] = character_perceptions
	
	.store_values()


func set_personal_values(new_values:Dictionary):
	personal_values = new_values
	
	emit_signal("values_changed", personal_values)

func set_character_perceptions(new_values:Dictionary):
	personal_values = new_values


func get_personal_values() -> Dictionary:
	return personal_values

func get_character_perceptions() -> Dictionary:
	return character_perceptions