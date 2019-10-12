extends VBoxContainer

export(NodePath) var default_speaker_node
export(Array, NodePath) var default_listener_nodes = []

export(NodePath) var description_node

onready var description_field = get_node(description_node)

var dialogue_option_scene = preload("res://dialogue_ui/dialogue_option.tscn")

var default_speaker:Character setget set_default_speaker, get_default_speaker
var default_listeners:Array = [] setget set_default_listeners, get_default_listeners

signal choice_made


func _enter_tree():
	default_speaker = get_node(default_speaker_node)
	
	for default_listener in default_listener_nodes:
		default_listeners.append(get_node(default_listener))

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("choice_made", description_field, "update_description")
	
	update_list_numbers()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_list_numbers()


func add_option():
	var new_option = dialogue_option_scene.instance()
	
	add_child(new_option)
	new_option.connect("option_confirmed", self, "choice_made")
	
	return new_option

func choice_made(updated_info):
	emit_signal("choice_made", updated_info["message"])

func update_list_numbers():
	var list_counter = 1
	
	for option in get_children():
		if option.visible:
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
