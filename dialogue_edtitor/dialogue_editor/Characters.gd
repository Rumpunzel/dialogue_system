extends TabContainer

const NEW_CHARACTER = "New Character"

export(PackedScene) var character_editor = preload("res://dialogue_editor/properties/Character Editor.tscn")

export(NodePath) var new_character_button


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(new_character_button).connect("pressed", self, "open_new_character")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func open_new_character(character_id:String = NEW_CHARACTER):
	var tabs = get_children()
	var has_character = -1
	
	if not character_id == NEW_CHARACTER:
		for i in range(1, tabs.size()):
			if tabs[i].name == character_id:
				has_character = i
				break
	
	if has_character < 0:
		var new_character_tab:character_editor = character_editor.instance()
		add_child(new_character_tab)
		new_character_tab.setup(character_id if not character_id == NEW_CHARACTER else "")
		
		has_character = (current_tab + 1) if not current_tab == 0 else tabs.size()
		move_child(new_character_tab, has_character)
		
		if not character_id == null:
			pass
	
	current_tab = has_character
