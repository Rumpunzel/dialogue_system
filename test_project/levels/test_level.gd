extends game_scene


# Called when the node enters the scene tree for the first time.
func _ready():
	# reset Klaus
	var klaus = $characters/Klaus
	klaus.memories.dialogue_memories = { }
	klaus.character_perceptions = { }
	# start the default dialogue for Klaus
	klaus.initiate_dialogue()
