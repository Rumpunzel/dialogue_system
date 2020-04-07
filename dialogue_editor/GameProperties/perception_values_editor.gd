extends values_list

export(NodePath) var reset_button


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(reset_button).connect("pressed", self, "update_entries", [GAME_CONSTANTS.PERCEPTION_VALUES])
	
	update_entries(GAME_CONSTANTS.PERCEPTION_VALUES)


func update_perception_globals(_new_text = ""):
	var new_perception_values:Array = []
	var entries = get_children()
	
	for entry in entries:
		if not entry.get_value() == "" and not new_perception_values.has(entry.get_value().to_lower()):
			new_perception_values.append(entry.get_value().to_lower())
	
	GAME_CONSTANTS.PERCEPTION_VALUES = new_perception_values

func save_changes():
	update_perception_globals()
