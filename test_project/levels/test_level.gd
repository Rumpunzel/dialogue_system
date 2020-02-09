extends game_scene


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# reset Klaus
	var klaus = $characters/Klaus
	klaus.memories.dialogue_memories = { }
	klaus.character_perceptions = { }
	# start the default dialogue for Klaus
	klaus.initiate_dialogue()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
