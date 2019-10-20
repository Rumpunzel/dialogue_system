extends BetterLineEdit

export(NodePath) var root_node

onready var editor_root:character_editor = get_node(root_node)

var NPC:NPC


# Called when the node enters the scene tree for the first time.
func _ready():
	editor_root.connect("current_NPC", self, "set_NPC")
	connect("text_confirmed", self, "update_name")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func update_name(new_name):
	if not editor_root.character_exists(new_name):
		editor_root.set_character_id(new_name)
	else:
		text = editor_root.NPC.id

func set_NPC(new_NPC):
	NPC = new_NPC
	text = NPC.id
