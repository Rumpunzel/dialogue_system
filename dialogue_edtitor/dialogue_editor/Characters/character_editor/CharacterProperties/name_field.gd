extends BetterLineEdit
class_name editor_name_field

export(NodePath) var root_node

onready var editor_root:character_editor = get_node(root_node)


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("text_confirmed", self, "update_name")


func update_name(new_name):
	if not editor_root.tab_exists(new_name):
		editor_root.tab_id = new_name
	else:
		text = editor_root.tab_id
