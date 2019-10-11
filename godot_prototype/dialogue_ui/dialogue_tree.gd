extends VBoxContainer

export(NodePath) var default_speaker_node
export(Array, NodePath) var default_listener_nodes = []

var default_speaker:Character setget set_default_speaker, get_default_speaker
var default_listeners:Array = [] setget set_default_listeners, get_default_listeners


# Called when the node enters the scene tree for the first time.
func _enter_tree():
	default_speaker = get_node(default_speaker_node)
	
	for default_listener in default_listener_nodes:
		default_listeners.append(get_node(default_listener))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func set_default_speaker(new_speaker):
	default_speaker = new_speaker

func set_default_listeners(new_listeners):
	default_listeners = new_listeners

func get_default_speaker():
	return default_speaker

func get_default_listeners():
	return default_listeners
