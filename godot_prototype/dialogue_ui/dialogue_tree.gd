extends VBoxContainer

export(NodePath) var default_speaker_node
export(Array, NodePath) var default_listener_nodes = []

export(NodePath) var description_node

onready var description_field = get_node(description_node)

var default_speaker:Character setget set_default_speaker, get_default_speaker
var default_listeners:Array = [] setget set_default_listeners, get_default_listeners

signal choice_made


func _enter_tree():
	default_speaker = get_node(default_speaker_node)
	
	for default_listener in default_listener_nodes:
		default_listeners.append(get_node(default_listener))
	
	for option in get_children():
		option.connect("option_confirmed", self, "choice_made")

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("choice_made", description_field, "update_description")
	
	update_list_numbers(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_list_numbers()


func choice_made(updated_info):
	emit_signal("choice_made", updated_info["description"])

func update_list_numbers(init = false):
	var list_counter = 1
	
	for option in get_children():
		if option.visible:
			if init:
				var new_shortcut = ShortCut.new() 
				new_shortcut.shortcut = InputEventKey.new()
				option.shortcut = new_shortcut
			
			option.shortcut.shortcut.scancode = KEY_0 + list_counter
			
			option.update_list_number(list_counter)
			
			list_counter += 1


func set_default_speaker(new_speaker):
	default_speaker = new_speaker

func set_default_listeners(new_listeners):
	default_listeners = new_listeners

func get_default_speaker():
	return default_speaker

func get_default_listeners():
	return default_listeners
