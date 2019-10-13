extends VBoxContainer

const DEFAULT_TREE = "000"

onready var description_field = $description
onready var dialogue_tree = $options_container/dialogue_tree

var current_dialogue:Dictionary
var current_tree

signal parsed_descriptions


# Called when the node enters the scene tree for the first time.
func _ready():
	dialogue_tree.connect("choice_made", self, "switch_tree")
	#dialogue_tree.connect("choice_made", description_field, "update_description")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func switch_dialogue(new_dialogue:Dictionary, new_tree = DEFAULT_TREE):
	current_dialogue = new_dialogue
	current_tree = new_tree
	
	parse_tree()

func switch_tree(update:Dictionary):
	var new_tree = update.get("new_tree", "")
	print(update)
	if not new_tree == "" and not new_tree == current_tree:
		current_tree = new_tree
		parse_tree(update)
	elif not update.get("message", []) == []:
		parse_tree(update)

func parse_tree(update:Dictionary = { }):
	var dialogue = current_dialogue.get(current_tree, { })
	
	var new_message = update.get("message", dialogue.get("message", [ ]))
	parse_descriptions(new_message)
	yield(self, "parsed_descriptions")
	
	var new_options = update.get("options", dialogue.get("options", [ ]))
	parse_options(new_options)

func parse_descriptions(descriptions:Array):
	while not descriptions.empty():
		update_description(descriptions.pop_front())
		yield(description_field, "finished_typing")
		
		if not descriptions.empty():
			dialogue_tree.add_option(dialogue_option.CONTINUE_OPTION)
			yield(dialogue_tree, "choice_made")
	
	emit_signal("parsed_descriptions")

func update_description(description):
	description_field.update_description({ "message": description })

func parse_options(options:Array):
	for option in options:
		dialogue_tree.add_option(option)
