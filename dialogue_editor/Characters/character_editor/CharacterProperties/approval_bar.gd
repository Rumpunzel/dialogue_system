extends BetterProgressBar


export(NodePath) var root_node


onready var editor_root: CharacterEditor = get_node(root_node).root_node


var NPC = null



# Called when the node enters the scene tree for the first time.
func _ready():
	editor_root.connect("current_NPC", self, "set_NPC")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not NPC == null:
		value = NPC.maximum_possible_approval_rating()


func set_NPC(new_NPC):
	NPC = new_NPC
