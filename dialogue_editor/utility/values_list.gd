extends VBoxContainer
class_name values_list

export(PackedScene) var entry_scene

export(NodePath) var save_button


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(save_button).connect("pressed", self, "save_changes")


func update_entries(new_values:Array):
	for i in new_values.size():
		var value = new_values[i]
		
		if i >= get_children().size():
			add_entry().name_entry(value)
		else:
			get_child(i).name_entry(value)

func add_entry():
	var entry = entry_scene.instance()
	entry.connect("option_confirmed", self, "parse_option")
	
	add_child(entry)
	
	return entry

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

func save_changes():
	pass

func up_or_down(id:int, up = -1, down = 1):
	return up if id & int(pow(2, menu_option.UP)) else down
