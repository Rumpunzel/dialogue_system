extends VBoxContainer

signal parsed_descriptions

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func start_dialogue(dialogue: Dictionary):
	var start_dialogue = dialogue.get("000", { })
	
	parse_dialogue(start_dialogue)

func parse_dialogue(dialogue: Dictionary):
	parse_descriptions(dialogue.get("description", []))
	yield(self, "parsed_descriptions")
	
	parse_options(dialogue.get("options", []))

func parse_descriptions(descriptions:Array):
	while not descriptions.empty():
		update_description(descriptions.pop_front())
		yield($description, "finished_typing")
		
		if not descriptions.empty():
			var continue_option:dialogue_option = $options_container/dialogue_tree.add_option()
			continue_option.init(dialogue_option.CONTINUE)
			yield(continue_option, "option_confirmed")
	
	emit_signal("parsed_descriptions")

func update_description(description):
	$description.update_description(description)

func parse_options(options:Array):
	for option in options:
		var new_option:dialogue_option = $options_container/dialogue_tree.add_option()
		new_option.init(dialogue_option.CUSTOM, option)
