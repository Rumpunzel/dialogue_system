tool
extends ToolButton
class_name dialogue_option

const DEFAULT = "default"
const CONTINUE = "continue"
const EXIT = "exit"
const CUSTOM = "custom"

const DEFAULT_OPTION = { "type": "default" }
const CONTINUE_OPTION =  { "type": "continue" }
const EXIT_OPTION =  { "type": "exit" }
const CUSTOM_OPTION =  { "type": "custom" }

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

export(float, 0, 1) var required_approval_rating

export(int, FLAGS, "Politeness", "Reliability", "Selflessness", "Sincerity") var values_enable_success

export(Array, String, MULTILINE) var success_messages
export var loop_successes_from = 0
#warning-ignore:unused_class_variable
export(String) var success_tree = ""

#warning-ignore:unused_class_variable
export(float, -1, 1) var approval_rating_change_on_success

export(Array, String, MULTILINE) var failure_messages
export var loop_failures_from = 0
#warning-ignore:unused_class_variable
export(String) var failure_tree = ""

#warning-ignore:unused_class_variable
export var single_use = true
export var exits_dialogue = false

export(Color) var big_deal_color = Color("FFD700")
export(float, 0, 1) var clicked_alpha = 0.5

onready var value_changes:Dictionary = compose_value_changes()

var speaker:Character
var listeners:Array = []

var click_status = UNTOUCHED

var success_counter = 0
var failure_counter = 0

var option_json:Dictionary
var noteworthy = true

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
	update_appearance()


func init(option_info = DEFAULT_OPTION):
	match option_info.get("type", CUSTOM):
		CONTINUE:
			name = "continue_option"
			text = "Continue."
			hint_tooltip = ""
			noteworthy = false
		EXIT:
			name = "exit_option"
			text = "Exit."
			hint_tooltip = ""
			exits_dialogue = true
			noteworthy = false
		DEFAULT:
			return
	
	option_json = option_info
	
	for key in option_info.keys():
		set(key, option_info[key])

func check_option():
	var new_click_status = max(check_success(), click_status)
	
	print("\n" + ("SUCCESS!" if new_click_status >= PASSED else "FAILURE!"))
		
	confirm_option(new_click_status >= PASSED)
	
#	if single_use:
#		queue_free()
#		#visible = false
	
	click_status = new_click_status
	
	if click_status >= PASSED:
		success_counter += 1
		if success_counter >= success_messages.size():
			success_counter = min(loop_successes_from, success_messages.size() -1)
	elif click_status >= CLICKED:
		failure_counter += 1
		if failure_counter >= failure_messages.size():
			failure_counter = min(loop_failures_from, failure_messages.size() -1)
	
	if exits_dialogue:
		get_tree().quit()

func check_success():
	var new_status = PASSED
	if required_approval_rating > 0:
		for listener in listeners:
			if listener.calculate_approval_rating(speaker) >= required_approval_rating:
				return PASSED
			else:
				new_status = CLICKED
	
	value_changes = compose_value_changes()
	
	for value in values_enable_success:
		if check_perception_for_listeners(value):
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
			
			for key in value_changes:
				var change = value_changes[key]
				if not change == 0:
					value_update += key + ": " + ("+" if change >= 0 else "") + str(change) + ", "
			
			print(value_update.substr(0, value_update.length() - 2))
		else:
			print("No Perception Updates, this Dialogue Option has already been used before!")
		
		for listener in listeners:
			listener.remember_response({ "speaker": speaker, "success": option_success, "value_changes": value_changes if click_status <= UNTOUCHED else { }, "approval_change": approval_rating_change_on_success, "big_deal": big_deal, "json": option_json, "noteworthy": noteworthy })
	else:
		print("No Updates, this Dialogue Option has already been passed before!")
	
	var success_message = success_messages[success_counter] if not success_messages.empty() else [ ]
	var failure_message = failure_messages[failure_counter] if not failure_messages.empty() else [ ]
	
	emit_signal("option_confirmed", { "success": option_success, "message": success_message if option_success else failure_message, "new_tree": success_tree if option_success else failure_tree, "big_deal": big_deal, "json": option_json })

func compose_value_changes():
	return { Character.POLITENESS: politeness_change, Character.RELIABILITY: reliability_change, Character.SELFLESSNESS: selflessness_change, Character.SINCERITY: sincerity_change }

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
