extends VBoxContainer

export(NodePath) var root_node setget , get_root_node

signal current_NPC


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(root_node).connect("current_NPC", self, "emit_NPC")


func emit_NPC(NPC):
	emit_signal("current_NPC", NPC)


func get_NPC():
	return get_node(root_node).NPC

func get_root_node():
	return get_node(root_node)
