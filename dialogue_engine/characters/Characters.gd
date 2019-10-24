extends Node
class_name Characters

var character_nodes:Dictionary


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func register_character(character_id:String, character_node:Character):
	character_nodes[character_id] = character_node

func unregister_character(character_id:String):
	character_nodes.erase(character_id)
