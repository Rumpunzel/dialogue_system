extends PanelContainer

export(PackedScene) var message_scene


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func parse_message(new_messages, new_name):
	var messages = $messages
	
	messages.get_node("label").text = new_name
	name = new_name
	
	for message in new_messages:
		if messages.get_child_count() > 1:
			var new_h_separator = HSeparator.new()
			messages.add_child(new_h_separator)
		
		var new_message = message_scene.instance()
		messages.add_child(new_message)
		new_message.set_message(message)
	
