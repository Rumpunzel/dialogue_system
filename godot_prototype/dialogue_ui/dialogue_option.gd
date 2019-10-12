tool
extends ToolButton
class_name dialogue_option

enum { UNTOUCHED, CLICKED, PASSED }
enum { DEFAULT, CUSTOM, CONTINUE, EXIT }

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
export(PackedScene) var success_tree

export(float, -1, 1) var approval_rating_change_on_success

export(Array, String, MULTILINE) var failure_messages
export var loop_failures_from = 0
export(PackedScene) var failure_tree

export var single_use = true
export var exits_dialogue = false

export(Color) var big_deal_color = Color("FFD700")
export(float, 0, 1) var clicked_alpha = 0.5

onready var value_changes:Array = [politeness_change, reliability_change, selflessness_change, sincerity_change]

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


func init(option_type = DEFAULT, option_info = { }):
	match option_type:
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
		CUSTOM:
			option_json = option_info
			
			name = option_info.get("title", name)
			text = option_info.get("text", text)
			hint_tooltip = option_info.get("tooltip", hint_tooltip)
			success_messages = option_info.get("success_messages", success_messages)
			failure_messages = option_info.get("failure_messages", failure_messages)
			big_deal = option_info.get("big_deal", big_deal)
			required_approval_rating = option_info.get("required_approval_rating", required_approval_rating)
			#"values_enable_success" : "Selflessness",
			loop_failures_from = option_info.get("loop_failures_from", loop_failures_from)
			value_changes[Character.POLITENESS] = option_info.get("politeness_change", politeness_change)
			value_changes[Character.RELIABILITY] = option_info.get("reliablity_change", reliability_change)
			value_changes[Character.SELFLESSNESS] = option_info.get("selflessness_change", selflessness_change)
			value_changes[Character.SINCERITY] = option_info.get("sincerity_change", sincerity_change)
			approval_rating_change_on_success = option_info.get("approval_rating_change_on_success", approval_rating_change_on_success)
			success_tree = option_info.get("change_to_root_on_success", success_tree)
			single_use = option_info.get("single_use", single_use)
			exits_dialogue = option_info.get("exit", exits_dialogue)
			noteworthy = option_info.get("noteworthy", noteworthy)
		_:
			pass

func check_option():
	var new_click_status = max(check_success(), click_status)
	
	print("\n" + ("SUCCESS!" if new_click_status >= PASSED else "FAILURE!"))
		
	confirm_option(new_click_status >= PASSED)
	
	if single_use:
		queue_free()
		#visible = false
	
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
			listener.remember_response({ "speaker": speaker, "success": option_success, "value_changes": value_changes if click_status <= UNTOUCHED else [], "approval_change": approval_rating_change_on_success, "big_deal": big_deal, "json": option_json, "noteworthy": noteworthy })
	else:
		print("No Updates, this Dialogue Option has already been passed before!")
	
	var success_message = success_messages[success_counter] if not success_messages.empty() else ""
	var failure_message = failure_messages[failure_counter] if not failure_messages.empty() else ""
	
	emit_signal("option_confirmed", { "success": option_success, "message": success_message if option_success else failure_message , "big_deal": big_deal, "json": option_json })

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
