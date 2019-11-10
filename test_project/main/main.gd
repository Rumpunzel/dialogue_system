extends Control


func _ready():
	var klaus = $Characters/Klaus
	klaus.memories.dialogue_memories = { }
	klaus.character_perceptions = { }
	klaus.initiate_dialogue($dialogue_window)
