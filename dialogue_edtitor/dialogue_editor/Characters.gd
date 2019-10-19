extends TabContainer

const NEW_CHARACTER = "NEW_CHARACTER"

export(PackedScene) var character_editor = preload("res://dialogue_editor/properties/Character Editor.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func open_new_character(character_id:String = NEW_CHARACTER):
	var tabs = get_children()
	var has_character = -1
	
	for i in tabs.size():
		if tabs[i].name == character_id:
			has_character = i
			break
	
	if has_character < 0:
		var new_character_tab:character_editor = character_editor.instance()
		new_character_tab.character_id = character_id
		add_child(new_character_tab)
		has_character = current_tab + 1
		move_child(new_character_tab, has_character)
		
		if not character_id == null:
			pass
	
	current_tab = has_character
