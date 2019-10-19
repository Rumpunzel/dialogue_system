extends BetterLineEdit

export(NodePath) var NPC_node

onready var NPC:NPC = get_node(NPC_node)


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("text_confirmed", self, "update_name")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func update_name(new_name):
	NPC.id = new_name
