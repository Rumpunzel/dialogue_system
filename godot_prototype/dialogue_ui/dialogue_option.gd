tool
extends ToolButton
class_name dialogue_option

enum { UNTOUCHED, CLICKED, PASSED }

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

export(Array, String, MULTILINE) var success_descriptions
export var loop_successes_from = 0
export(PackedScene) var success_tree

export(float, -1, 1) var approval_rating_change_on_success

export(Array, String, MULTILINE) var failure_descriptions
export var loop_failures_from = 0
export(PackedScene) var failure_tree

export var single_use = true

export(Color) var big_deal_color = Color("FFD700")
export(float, 0, 1) var clicked_alpha = 0.5

onready var value_changes:Array = [politeness_change, reliability_change, selflessness_change, sincerity_change]

var speaker:Character
var listeners:Array = []

var click_status = UNTOUCHED

var success_counter = 0
var failure_counter = 0

signal option_confirmed


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
	
	reevaluate_availability()


func check_option():
	var new_click_status = max(check_success(), click_status)
	
	print("\n" + ("SUCCESS!" if new_click_status >= PASSED else "FAILURE!"))
		
	confirm_option(new_click_status >= PASSED)
	
	if single_use:
		visible = false
	
	click_status = new_click_status
	
	if click_status >= PASSED:
		success_counter += 1
		if success_counter >= success_descriptions.size():
			success_counter = min(loop_successes_from, success_descriptions.size() -1)
	elif click_status >= CLICKED:
		failure_counter += 1
		if failure_counter >= failure_descriptions.size():
			failure_counter = min(loop_failures_from, failure_descriptions.size() -1)
	
	update_appearance()

func check_success():
	var new_status = PASSED
	if required_approval_for_success > 0:
		for listener in listeners:
			if listener.calculate_approval_rating(speaker) >= required_approval_for_success:
				return PASSED
			else:
				new_status = CLICKED
	
	for i in Character.VALUE_NAMES.size():
		if int(pow(2, i)) & values_enable_success:
			if check_perception_for_listeners(i):
				return PASSED
			else:
				new_status = CLICKED
	
	return new_status

func check_perception_for_listeners(value):
	for listener in listeners:
		var values = listener.calculate_perception_value(listener.character_perceptions.get(speaker, [speaker.percieved_starting_values])[NPC.PERCEPTION_VALUES])
		
		if not listener.personal_values[value] == 0 and values[value] / listener.personal_values[value] < 1:
			return false
	
	return true

func confirm_option(option_success):
	if click_status < PASSED:
		if click_status <= UNTOUCHED:
			var value_update = ""
			for i in value_changes.size():
				var change = value_changes[i]
				if not change == 0:
					value_update += Character.VALUE_NAMES[i] + ": " + ("+" if change >= 0 else "") + str(change) + ", "
			print(value_update.substr(0, value_update.length() - 2))
		else:
			print("No Perception Updates, this Dialogue Option has already been used before!")
		
		for listener in listeners:
			listener.remember_response(speaker, self, option_success, value_changes if click_status <= UNTOUCHED else [], approval_rating_change_on_success, big_deal)
	else:
		print("No Updates, this Dialogue Option has already been passed before!")
	
	var success_description = success_descriptions[success_counter] if not success_descriptions.empty() else ""
	var failure_description = failure_descriptions[failure_counter] if not failure_descriptions.empty() else ""
	
	emit_signal("option_confirmed", { "success": option_success, "tree": success_tree if option_success else failure_tree, "description": success_description if option_success else failure_description })

func reevaluate_availability():
	if visible == false and check_success() > click_status:
		visible = true

func update_appearance():
	if big_deal:
		set("custom_colors/font_color", big_deal_color)
	else:
		set("custom_colors/font_color", null)
		
		if click_status >= CLICKED:
			modulate.a = clicked_alpha

func update_list_number(new_number):
	$list_number.text = "%d." % [new_number]
