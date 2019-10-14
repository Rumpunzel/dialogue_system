extends VBoxContainer

export(NodePath) var default_speaker_node
export(Array, NodePath) var default_listener_nodes = []

export(PackedScene) var dialogue_option_scene = preload("res://dialogue_ui/dialogue_option/dialogue_option.tscn")

var default_speaker:Character setget set_default_speaker, get_default_speaker
var default_listeners:Array = [] setget set_default_listeners, get_default_listeners

signal choice_made


func _enter_tree():
	default_speaker = get_node(default_speaker_node)
	
	for default_listener in default_listener_nodes:
		default_listeners.append(get_node(default_listener))

# Called when the node enters the scene tree for the first time.
func _ready():
	update_list_numbers()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func add_option(option_id:String, option_type):
	var speaker_check = option_type.get("speaker", default_speaker)
	var listeners_check = option_type.get("listeners", default_listeners)
	
	var success_counter = 0
	var failure_counter = 0
	
	if not option_id.begins_with("_"):
		for listener in listeners_check:
			var recollection = listener.remembers_dialogue_option(option_id)
			
			if not recollection == null and recollection["speaker"] == speaker_check:
				success_counter = recollection["success_counter"]
				failure_counter = recollection["failure_counter"]
	
	var new_option = dialogue_option_scene.instance()
	new_option.init(option_id, option_type)
	new_option.speaker = speaker_check
	new_option.listeners = listeners_check
	new_option.success_counter = success_counter
	new_option.failure_counter = failure_counter
	
	if not option_type.get("single_use", true) or (success_counter == 0 and failure_counter == 0) or (option_type.get("big_deal", false) and success_counter == 0 and new_option.check_success() >= dialogue_option.PASSED):
		add_child(new_option)
		new_option.connect("option_confirmed", self, "choice_made")
	else:
		new_option.queue_free()

func choice_made(updated_info):
	clear_options()
	emit_signal("choice_made", updated_info)

func update_list_numbers():
	var list_counter = 1
	
	for option in get_children():
		var new_shortcut = ShortCut.new() 
		new_shortcut.shortcut = InputEventKey.new()
		new_shortcut.shortcut.scancode = KEY_0 + list_counter
		option.shortcut = new_shortcut
		
		option.update_list_number(list_counter)
		
		list_counter += 1

func clear_options():
	for option in get_children():
		option.queue_free()


func set_default_speaker(new_speaker):
	default_speaker = new_speaker

func set_default_listeners(new_listeners):
	default_listeners = new_listeners

func get_default_speaker():
	return default_speaker

func get_default_listeners():
	return default_listeners
