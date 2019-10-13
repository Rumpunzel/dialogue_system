extends Node
class_name memories

const PASSED = "passed"
const FAILED = "failed"
const BIG_DEAL = "big_deal"
const NORMAL = "normal"

const SUCCESS_MAP = { true: PASSED, false: FAILED }
const BIG_DEAL_MAP = { true: BIG_DEAL, false: NORMAL }

onready var dialogue_memories:Dictionary = { BIG_DEAL: { PASSED: { }, FAILED: { } }, NORMAL: { PASSED: { }, FAILED: { } } }


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
		dialogue_memories[big_deal_status][success_status][new_memory["id"]] = new_memory

func remembers_dialogue_option(unique_id):
	for memory_category in dialogue_memories.values():
		for dialogue_states in memory_category.values():
			var memory = dialogue_states.get(unique_id)
			
			if not memory == null:
				return memory
	
	return null
