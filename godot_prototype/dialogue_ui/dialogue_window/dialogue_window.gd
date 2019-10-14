extends VBoxContainer

const DEFAULT_TREE = "start"

export(NodePath) var default_speaker_node
export(Array, NodePath) var default_listener_nodes = []

export(String, FILE, "*.json") var dialogue_options_file_path

onready var description_field = $description_field
onready var dialogue_tree = $options_tree

var default_speaker:Character setget set_default_speaker, get_default_speaker
var default_listeners:Array = [] setget set_default_listeners, get_default_listeners

var dialogue_options:Dictionary

var current_dialogue:Dictionary
var current_tree
var current_options:Dictionary

var first_time = true

signal parsed_descriptions


func _enter_tree():
	default_speaker = get_node(default_speaker_node)
	
	for default_listener in default_listener_nodes:
		default_listeners.append(get_node(default_listener))

# Called when the node enters the scene tree for the first time.
func _ready():
	dialogue_options = json_helper.load_json(dialogue_options_file_path)
	
	dialogue_tree.connect("choice_made", self, "switch_tree")
	
	connect("parsed_descriptions", self, "parse_options")

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

func parse_tree(update:Dictionary = { }):
	var dialogue = current_dialogue.get(current_tree, { })
	
	var new_message:Array = update.get("message", [ ])
	var default_message:Array = (dialogue.get("greeting", [ ]) if first_time else [ ]) + dialogue.get("message", [ ])
	first_time = false
	
	new_message = default_message if new_message.empty() else new_message
	parse_descriptions(new_message.duplicate())
	
	current_options = update.get("options", dialogue.get("options", { }))

func parse_descriptions(descriptions:Array):
	update_description(descriptions.pop_front())
	yield(description_field, "finished_typing")
	
	if not descriptions.empty():
		var continue_info = dialogue_option.CONTINUE_OPTION
		continue_info["success_messages"] = [descriptions]
		dialogue_tree.add_option(dialogue_option.CONTINUE, continue_info)
		dialogue_tree.update_list_numbers()
	else:
		emit_signal("parsed_descriptions")

func update_description(description):
	description_field.update_description({ "message": description })

func parse_options(options:Dictionary = current_options):
	for option_id in options.keys():
		var option_info:Dictionary = dialogue_options.get(option_id, dialogue_option.CUSTOM_OPTION)
		
		var type = option_info.get("type", option_id)
		
		for tree_change in options[option_id].keys():
			option_info[tree_change] = options[option_id][tree_change]
		
		dialogue_tree.add_option(type, option_info)
	
	dialogue_tree.update_list_numbers()


func set_default_speaker(new_speaker):
	default_speaker = new_speaker

func set_default_listeners(new_listeners):
	default_listeners = new_listeners

func get_default_speaker():
	return default_speaker

func get_default_listeners():
	return default_listeners
