class_name DefaultEditor, "res://dialogue_editor/assets/icons/icon_default_editor.svg"
extends TabContainer


export var new_tab_name = "New Tab"

export(PackedScene) var tab_scene

export(NodePath) var new_tab_button
export(NodePath) var directory




# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(new_tab_button).connect("pressed", self, "open_new_tab")




func open_new_tab(tab_path:String = "", tab_name:String = new_tab_name):
	var tabs = get_children()
	var has_tab = -1
	
	if tab_path == "":
		tab_path = "%s%s" % [get_file_directory().plus_file(new_tab_name), get_file_extension()]
	
	if not tab_name == new_tab_name:
		for i in range(1, tabs.size()):
			if tabs[i].name == tab_name:
				has_tab = i
				break
	
	if has_tab < 0:
		var new_tab = tab_scene.instance()
		
		add_child(new_tab)
		
		new_tab.setup(tab_name, tab_path)
		
		has_tab = (current_tab + 1) if not current_tab == 0 else tabs.size()
		move_child(new_tab, has_tab)
		
		if not tab_name == null:
			pass
	
	current_tab = has_tab




func get_file_directory():
	return get_node(directory).get_entry_directory()


func get_file_extension():
	return get_node(directory).get_file_ending()
