extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	update_perception_entries(GAME_CONSTANTS._PERCEPTION_VALUES)
	
	name_entry(add_entry(), "")


func update_perception_entries(new_perception_values:Array):
	for perception in new_perception_values:
		name_entry(add_entry(), perception)

func update_perception_globals(_new_text):
	var new_perception_values:Array = []
	var entries = get_children()
	
	for entry in entries:
		if not entry.text == "":
			new_perception_values.append(entry.text.to_lower())
	
	GAME_CONSTANTS.set_PERCEPTION_VALUES(new_perception_values)
	
	for i in entries.size():
		if i < new_perception_values.size():
			name_entry(entries[i], new_perception_values[i])
		else:
			entries[i].queue_free()
	
	name_entry(add_entry(), "")

func add_entry():
	var perception_field = LineEdit.new()
	perception_field.connect("text_entered", self, "update_perception_globals")
	
	add_child(perception_field)
	
	return perception_field

func name_entry(entry, new_name):
	print(new_name)
	entry.text = new_name.capitalize()
	entry.name = "%s_%s" % [new_name, "field"]
