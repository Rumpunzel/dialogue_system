extends TabContainer

export(String) var main_tab_name

export(NodePath) var main_tab


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(main_tab).name = main_tab_name

