extends TabContainer
class_name default_editor

export var new_tab_name = "New Tab"

export(PackedScene) var tab_scene

export(NodePath) var new_tab_button


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(new_tab_button).connect("pressed", self, "open_new_tab")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func open_new_tab(tab_id:String = new_tab_name):
	var tabs = get_children()
	var has_tab = -1
	
	if not tab_id == new_tab_name:
		for i in range(1, tabs.size()):
			if tabs[i].name == tab_id:
				has_tab = i
				break
	
	if has_tab < 0:
		var new_tab = tab_scene.instance()
		add_child(new_tab)
		new_tab.setup(tab_id if not tab_id == new_tab_name else "")
		
		has_tab = (current_tab + 1) if not current_tab == 0 else tabs.size()
		move_child(new_tab, has_tab)
		
		if not tab_id == null:
			pass
	
	current_tab = has_tab