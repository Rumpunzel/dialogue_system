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

export(float, 0, 1) var required_approval_for_success = 0

export(int, FLAGS, "Politeness", "Reliability", "Selflessness", "Sincerity") var values_enable_success

onready var value_changes:Array = [politeness_change, reliability_change, selflessness_change, sincerity_change]

var speaker:Character
var listeners:Array = []


# Called when the node enters the scene tree for the first time.
func _ready():
	update_appearance()
	
	connect("button_up", self, "check_option")
	
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


func check_option():
	var option_success = check_success()
	
	print("\n" + ("SUCCESS!" if option_success else "FAILURE!"))
	
	confirm_option(option_success)

func check_success():
	var success = true
	
	if required_approval_for_success > 0:
		for listener in listeners:
			if listener.calculate_approval_rating(speaker) >= required_approval_for_success:
				return true
			else:
				success = false
	
	for i in Character.VALUE_NAMES.size():
		if int(pow(2, i)) & values_enable_success:
			if check_perception_for_listeners(i):
				return true
			else:
				success = false
	
	return success

func check_perception_for_listeners(value):
	for listener in listeners:
		var values = listener.calculate_perception_value(listener.character_perceptions.get(speaker, speaker.percieved_starting_values))
		
		if not listener.personal_values[value] == 0 and values[value] / listener.personal_values[value] < 1:
			return false
	
	return true

func confirm_option(option_success):
	var value_update = ""
	for i in value_changes.size():
		var change = value_changes[i]
		if not change == 0:
			value_update += Character.VALUE_NAMES[i] + ": " + ("+" if change >= 0 else "") + str(change) + ", "
	print(value_update.substr(0, value_update.length() - 2))
	
	for listener in listeners:
		listener.remember_response(speaker, option_success, value_changes, big_deal)

func update_appearance():
	if big_deal:
		set("custom_colors/font_color", Color("FFD700"))
	else:
		set("custom_colors/font_color", null)
