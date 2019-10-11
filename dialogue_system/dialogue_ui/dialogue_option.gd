tool
extends ToolButton

export(NodePath) var speaker_node = null
export(Array, NodePath) var listener_nodes = []

#warning-ignore:unused_class_variable
export(int, -10, 10) var politeness_change
#warning-ignore:unused_class_variable
export(int, -10, 10) var reliability_change
#warning-ignore:unused_class_variable
export(int, -10, 10) var selflessness_change
#warning-ignore:unused_class_variable
export(int, -10, 10) var sincerity_change

export var big_deal:bool = false

export(float, 0, 1) var required_approval_for_success

onready var value_changes:Array = [politeness_change, reliability_change, selflessness_change, sincerity_change]

var speaker:Character
var listeners:Array = []


# Called when the node enters the scene tree for the first time.
func _ready():
	update_appearance()
	
	connect("button_up", self, "option_chosen")
	
	if not speaker_node == null:
		speaker = get_node(speaker_node)
	else:
		speaker = get_parent().default_speaker
	
	if not listener_nodes.empty():
		for listener in listener_nodes:
			listeners.append(get_node(listener))
	else:
		listeners = get_parent().default_listeners

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Engine.editor_hint:
		update_appearance()


func option_chosen():
	var value_update = ""
	for i in value_changes.size():
		var change = value_changes[i]
		if not change == 0:
			value_update += Character.VALUE_NAMES[i] + ": " + ("+" if change >= 0 else "") + str(change) + ", "
	print(value_update.substr(0, value_update.length() - 2))
	
	for listener in listeners:
		listener.remember_response(speaker, value_changes, big_deal)

func update_appearance():
	if big_deal:
		set("custom_colors/font_color", Color("FFD700"))
	else:
		set("custom_colors/font_color", null)
