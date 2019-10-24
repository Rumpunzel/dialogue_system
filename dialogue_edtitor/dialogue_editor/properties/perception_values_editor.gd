extends VBoxContainer

export(PackedScene) var entry_scene = preload("res://dialogue_editor/properties/entry_container.tscn")

export(NodePath) var save_button
export(NodePath) var reset_button


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(save_button).connect("pressed", self, "update_perception_globals")
	get_node(reset_button).connect("pressed", self, "update_perception_entries", [GAME_CONSTANTS.PERCEPTION_VALUES])
	
	update_perception_entries(GAME_CONSTANTS.PERCEPTION_VALUES)


func update_perception_entries(new_perception_values:Array):
	for i in new_perception_values.size():
		var perception = new_perception_values[i]
		
		if i >= get_children().size():
			add_entry().name_entry(perception)
		else:
			get_child(i).name_entry(perception)

func update_perception_globals(_new_text = ""):
	var new_perception_values:Array = []
	var entries = get_children()
	
	for entry in entries:
		if not entry.get_value() == "" and not new_perception_values.has(entry.get_value().to_lower()):
			new_perception_values.append(entry.get_value().to_lower())
	
	GAME_CONSTANTS.PERCEPTION_VALUES = new_perception_values

func add_entry():
	var perception_field = entry_scene.instance()
	perception_field.connect("option_confirmed", self, "parse_option")
	
	add_child(perception_field)
	
	return perception_field

func parse_option(entry, id):
	if id & int(pow(2, menu_option.DELETE)):
		entry.queue_free()
		remove_child(entry)
	else:
		var current_index = get_children().find(entry)
		
		if id & int(pow(2, menu_option.MOVE)):
			move_child(entry, current_index + up_or_down(id))
		elif id & int(pow(2, menu_option.INSERT)):
			var new_entry = add_entry()
			move_child(new_entry, current_index + up_or_down(id, 0))
			
			new_entry.entry_field.grab_focus()

func up_or_down(id:int, up = -1, down = 1):
	return up if id & int(pow(2, menu_option.UP)) else down
