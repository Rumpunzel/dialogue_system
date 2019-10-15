extends VBoxContainer

export(PackedScene) var dialogue_option_scene = preload("res://dialogue_ui/dialogue_option/dialogue_option.tscn")

signal choice_made


# Called when the node enters the scene tree for the first time.
func _ready():
	update_list_numbers()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func add_option(option_id:String, option_type = null):
	var speaker_check = get_default_speaker()
	var listeners_check = get_default_listeners()
	
	var success_counter = 0
	var failure_counter = 0
	
	if not option_type == null:
		speaker_check = option_type.get("speaker", speaker_check)
		listeners_check = option_type.get("listeners", listeners_check)
		
		if not option_id.begins_with("_"):
			for listener in listeners_check:
				var recollection = listener.remembers_dialogue_option(option_id)
				
				if not recollection == null and recollection["speaker"] == speaker_check:
					success_counter = recollection["success_counter"]
					failure_counter = recollection["failure_counter"]
	
	var new_option = dialogue_option_scene.instance()
	new_option.speaker = speaker_check
	new_option.listeners = listeners_check
	new_option.success_counter = success_counter
	new_option.failure_counter = failure_counter
	
	if not option_type == null:
		new_option.init(option_id, option_type)
		
		if not option_type.get("single_use", true) or (success_counter == 0 and failure_counter == 0) or (option_type.get("big_deal", false) and success_counter == 0 and new_option.check_success() >= dialogue_option.PASSED):
			add_option_to_tree(new_option)
		else:
			new_option.queue_free()
	else:
		new_option.init(option_id)
		
		add_option_to_tree(new_option)

func add_option_to_tree(new_option):
	add_child(new_option)
	new_option.connect("option_confirmed", self, "choice_made")

func choice_made(updated_info):
	clear_options()
	emit_signal("choice_made", updated_info)

func update_list_numbers():
	var list_counter = 1
	
	for option in get_children():
		var new_shortcut = ShortCut.new() 
		new_shortcut.shortcut = InputEventKey.new()
		new_shortcut.shortcut.scancode = KEY_0 + list_counter
		option.set_shortcut(new_shortcut)
		
		option.update_list_number(list_counter)
		
		list_counter += 1

func clear_options():
	for option in get_children():
		option.queue_free()


func get_default_speaker():
	return get_parent().default_speaker

func get_default_listeners():
	return get_parent().default_listeners
