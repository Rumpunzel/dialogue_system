extends BetterProgressBar

export(NodePath) var NPC_node

onready var NPC:NPC = get_node(NPC_node)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	value = NPC.maximum_possible_approval_rating()
