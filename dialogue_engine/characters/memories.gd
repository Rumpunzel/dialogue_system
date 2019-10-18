extends Node
class_name memories

enum { PASSED, FAILED }
enum { NORMAL, BIG_DEAL }

const SUCCESS_MAP = { true: PASSED, false: FAILED }
const BIG_DEAL_MAP = { true: BIG_DEAL, false: NORMAL }

const DEFAULT_MEMORY_PATH:String = "res://data/memores/%s_memory.json"

const DEFAULT_MEMORY:Dictionary = { NORMAL: { PASSED: { }, FAILED: { } }, BIG_DEAL: { PASSED: { }, FAILED: { } } }

var memory_path:String

var dialogue_memories:Dictionary


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func remember_response(new_memory:Dictionary):
	if new_memory.get("noteworthy", false):
		var big_deal_status = BIG_DEAL_MAP[new_memory.get("big_deal", false)]
		var success_status = SUCCESS_MAP[new_memory.get("success", true)]
		
		if dialogue_memories.empty():
			dialogue_memories = DEFAULT_MEMORY
		
		dialogue_memories[big_deal_status][success_status][new_memory["id"]] = new_memory
	
	#store_values()

func remembers_dialogue_option(unique_id):
	for memory_category in dialogue_memories.values():
		for dialogue_states in memory_category.values():
			var memory = dialogue_states.get(unique_id)
			
			if not memory == null:
				return memory
	
	return null

func load_values(character_id:String):
	memory_path = DEFAULT_MEMORY_PATH % [character_id]
	var loaded_json = json_helper.load_json(memory_path)
	dialogue_memories = loaded_json if not loaded_json == null else { }

func store_values():
	json_helper.save_json(dialogue_memories, memory_path)
