extends GridContainer

export(String) var default_speaker:String setget set_default_speaker, get_default_speaker
export(Array, String) var default_listeners:Array = [] setget set_default_listeners, get_default_listeners

export(String, FILE, "*.json") var dialogue_options_file_path

onready var speaker_name = $speaker_name
onready var description_field = $description_field
onready var dialogue_tree = $options_tree

var dialogue_options:Dictionary

var current_dialogue:Dictionary
var current_tree_stack:Array
var current_options:Dictionary

var first_time = true

signal parsed_descriptions


# Called when the node enters the scene tree for the first time.
func _ready():
	#default_speaker = get_node(default_speaker_node).id
	
	dialogue_options = json_helper.load_json(dialogue_options_file_path)
	
	dialogue_tree.connect("choice_made", self, "switch_tree")
	
	connect("parsed_descriptions", self, "parse_options")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func switch_dialogue(new_dialogue:Dictionary, new_tree = CONSTANTS.DEFAULT_TREE):
	current_dialogue = new_dialogue
	current_tree_stack.push_front(new_tree)
	
	parse_tree()

func switch_tree(update:Dictionary):
	var new_tree = update.get("new_tree", "")
	
	if not new_tree == "" and not new_tree == current_tree_stack.front():
		current_tree_stack.push_front(new_tree)
	elif update.get("is_back_option", false):
		current_tree_stack.pop_front()
	
	parse_tree(update)

func parse_tree(update:Dictionary = { }):
	var dialogue = current_dialogue.get(current_tree_stack.front(), { })
	
	var new_message:Array = update.get("message", [ ])
	var greeting_message:Array = dialogue["greeting"] if first_time else [ ]
	var message = dialogue["message"]
	
	first_time = false 
	
	new_message = (greeting_message + message) if new_message.empty() else new_message
	
	parse_descriptions(new_message.duplicate())
	
	current_options = update.get("options", dialogue.get("options", { }))

func parse_descriptions(descriptions:Array):
	var new_description:Dictionary = descriptions.pop_front()
	
	update_speaker(new_description.get("speaker", ""))
	update_description(new_description["text"])
	yield(description_field, "finished_typing")
	
	if not descriptions.empty():
		var continue_info = dialogue_option.CONTINUE_JSON
		continue_info["success_messages"] = [descriptions]
		
		dialogue_tree.add_option(CONSTANTS.CONTINUE_OPTION, continue_info)
		dialogue_tree.update_list_numbers()
	else:
		emit_signal("parsed_descriptions")

func update_speaker(speaker):
	if not speaker == null:
		if typeof(speaker) == TYPE_REAL:
			speaker = default_listeners[min(int(speaker), default_listeners.size() - 1)]
		
		if not speaker_name.text == speaker + ":":
			speaker_name.type_text("[right]<%s:>[/right]" % [speaker] if speaker.length() > 0 else "")
	else:
		speaker_name.text = ""

func update_description(description):
	if not description == null:
		description_field.update_description({ "message": description })

func parse_options(options:Dictionary = current_options):
	var has_option:Dictionary = { }
	
	for option_id in options.keys():
		var option_info:Dictionary = dialogue_options.get(option_id, dialogue_option.CUSTOM_JSON)
		
		var type = option_info.get("type", option_id)
		has_option[type] = has_option.get(type, 0) + 1
		
		for tree_change in options[option_id].keys():
			option_info[tree_change] = options[option_id][tree_change]
		
		dialogue_tree.add_option(type, option_info)
	
	if not current_dialogue[current_tree_stack.front()].get("sub_tree", false):
		if not has_option.get(CONSTANTS.EXIT_OPTION, 0) > 0:
			dialogue_tree.add_option(CONSTANTS.EXIT_OPTION)
	else:
		if not has_option.get(CONSTANTS.BACK_OPTION, 0) > 0:
			dialogue_tree.add_option(CONSTANTS.BACK_OPTION)
	
	dialogue_tree.update_list_numbers()


func set_default_speaker(new_speaker):
	default_speaker = new_speaker

func set_default_listeners(new_listeners):
	default_listeners = new_listeners

func get_default_speaker():
	return default_speaker

func get_default_listeners():
	return default_listeners
