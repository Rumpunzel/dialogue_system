extends VBoxContainer

const DEFAULT_TREE = "start"

export(String, FILE, "*.json") var dialogue_options_file_path

onready var description_field = $description
onready var dialogue_tree = $dialogue_tree

var dialogue_options:Dictionary

var current_dialogue:Dictionary
var current_tree

signal parsed_descriptions


# Called when the node enters the scene tree for the first time.
func _ready():
	dialogue_options = json_helper.load_json(dialogue_options_file_path)
	
	dialogue_tree.connect("choice_made", self, "switch_tree")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func switch_dialogue(new_dialogue:Dictionary, new_tree = DEFAULT_TREE):
	current_dialogue = new_dialogue
	current_tree = new_tree
	
	parse_tree()

func switch_tree(update:Dictionary):
	var new_tree = update.get("new_tree", "")
	
	if not new_tree == "" and not new_tree == current_tree:
		current_tree = new_tree
		parse_tree(update)
	elif not update.get("message", []) == []:
		parse_tree(update)

func parse_tree(update:Dictionary = { }):
	var dialogue = current_dialogue.get(current_tree, { })
	
	var new_message = update.get("message", [ ])
	new_message = dialogue.get("message", [ ]) if new_message.empty() else new_message
	parse_descriptions(new_message.duplicate())
	yield(self, "parsed_descriptions")
	
	var new_options = update.get("options", dialogue.get("options", { }))
	parse_options(new_options)

func parse_descriptions(descriptions:Array):
	while not descriptions.empty():
		update_description(descriptions.pop_front())
		yield(description_field, "finished_typing")
		
		if not descriptions.empty():
			dialogue_tree.add_option(dialogue_option.CONTINUE, dialogue_option.CONTINUE_OPTION)
			dialogue_tree.update_list_numbers()
			yield(dialogue_tree, "choice_made")
	
	emit_signal("parsed_descriptions")

func update_description(description):
	description_field.update_description({ "message": description })

func parse_options(options:Dictionary):
	for option_id in options.keys():
		var option_info:Dictionary = dialogue_options.get(option_id, { })
		
		var type = option_info.get("type", option_id)
		
		for tree_change in options[option_id].keys():
			option_info[tree_change] = options[option_id][tree_change]
		
		dialogue_tree.add_option(type, option_info)
	
	dialogue_tree.update_list_numbers()
