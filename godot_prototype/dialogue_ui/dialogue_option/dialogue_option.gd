extends Label
class_name dialogue_option

enum { UNTOUCHED, CLICKED, PASSED }

const CONTINUE = "_continue_option"
const EXIT = "_exit_option"
const CUSTOM = "custom_option"

const CONTINUE_OPTION = { text = "Continue.", hint_tooltip = "", noteworthy = false }
const EXIT_OPTION = { text = "Exit.", hint_tooltip = "", noteworthy = false, exits_dialogue = true }
const CUSTOM_OPTION = { }

export(String) var speaker
export(Array, String) var listeners

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

export(Array, Array, String, MULTILINE) var success_messages = [ [ ] ]
export var loop_successes_from = 0
#warning-ignore:unused_class_variable
export(String) var success_tree = ""

#warning-ignore:unused_class_variable
export(float, -1, 1) var approval_rating_change_on_success

export(Array, Array, String, MULTILINE) var failure_messages = [ [ ] ]
export var loop_failures_from = 0
#warning-ignore:unused_class_variable
export(String) var failure_tree = ""

#warning-ignore:unused_class_variable
export var single_use = true
export var exits_dialogue = false

export(Color) var big_deal_color = Color("FFD700")
export(float, 0, 1) var clicked_alpha = 0.5

onready var value_changes:Dictionary = compose_value_changes()

#warning-ignore:unused_class_variable
var id

var success_counter = 0
var failure_counter = 0

var option_json:Dictionary

var option_text:Dictionary
var loop_success_option_text_from = 0
var loop_failure_option_text_from = 0

var noteworthy = true

var dialogue_counter = ""

var option_number
var dialogue_option

signal option_confirmed


# Called when the node enters the scene tree for the first time.
func _ready():
	update_appearance()
	
	$option_button.connect("button_up", self, "check_option")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Engine.editor_hint:
		update_appearance()

#func _input(event):
#	if event is InputEventKey:# and event.scancode == shortcut.shortcut.scancode:
#		print(event)
#		pressed = true


func init(option_id:String, option_info:Dictionary = CUSTOM_OPTION):
	option_number = $option_text/option_number
	dialogue_option = $option_text/dialogue_option
	
	id = option_id
	name = id
	
	match option_id:
		CONTINUE:
			parse_option(CONTINUE_OPTION)
		EXIT:
			parse_option(EXIT_OPTION)
	
	option_json = option_info
	
	parse_option(option_json)

func parse_option(option_info):
	for key in option_info.keys():
		set(key, option_info[key])
	
	var success = success_counter >= failure_counter
	var opt_txt:Array = option_text.get("success" if success else "failure", [ text ])
	var new_option_text = opt_txt[abs(math_helper.calculate_loop_modulo(success_counter if success else failure_counter, opt_txt.size(), loop_success_option_text_from if success else loop_failure_option_text_from))]
	
	text = new_option_text
	dialogue_option.type_text(new_option_text)

func check_option():
	var new_click_status = check_success()
	
	print("\n" + ("SUCCESS!" if new_click_status >= PASSED else "FAILURE!"))
	
	if new_click_status >= PASSED:
		success_counter += 1
	elif new_click_status >= CLICKED:
		failure_counter += 1
	
	confirm_option(new_click_status >= PASSED)
	
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
	if success_counter <= 1:
		if failure_counter <= 1:
			var value_update = ""
			
			for key in value_changes.keys():
				var change = value_changes[key]
				if not change == 0:
					value_update += key + ": " + ("+" if change >= 0 else "") + str(change) + ", "
			
			print(value_update.substr(0, value_update.length() - 2))
		else:
			print("No Perception Updates, this Dialogue Option has already been used before!")
	else:
		print("No Updates, this Dialogue Option has already been passed before!")
	
	for listener in listeners:
		listener.remember_response({ "id": id, "speaker": speaker, "listeners": listeners, "success": option_success, "value_changes": value_changes if untouched(1) else { }, "approval_change": approval_rating_change_on_success, "big_deal": big_deal, "success_counter": success_counter, "failure_counter": failure_counter, "json": option_json, "noteworthy": noteworthy })
	
	var succ_mess = math_helper.calculate_loop_modulo(success_counter - 1, success_messages.size(), loop_successes_from)
	var fail_mess = math_helper.calculate_loop_modulo(failure_counter - 1, failure_messages.size(), loop_failures_from)
			
	var success_message = success_messages[succ_mess] if not success_messages.empty() else [ ]
	var failure_message = failure_messages[fail_mess] if not failure_messages.empty() else [ ]
	
	emit_signal("option_confirmed", { "success": option_success, "message": success_message if option_success else failure_message, "new_tree": success_tree if option_success else failure_tree, "big_deal": big_deal, "json": option_json })

func compose_value_changes():
	return { Character.POLITENESS: politeness_change, Character.RELIABILITY: reliability_change, Character.SELFLESSNESS: selflessness_change, Character.SINCERITY: sincerity_change }

func update_appearance():
	if big_deal:
		option_number.set("custom_colors/font_color", big_deal_color)
		dialogue_option.set("custom_colors/default_color", big_deal_color)
	else:
		option_number.set("custom_colors/font_color", null)
		dialogue_option.set("custom_colors/default_color", null)
		
		if not untouched():
			option_number.modulate.a = clicked_alpha
			dialogue_option.modulate.a = clicked_alpha

func untouched(bigger_than = 0):
	return success_counter + failure_counter <= bigger_than

func update_list_number(new_number):
	dialogue_counter = "%d." % [new_number]
	text = "%s %s" % [dialogue_counter, text]
	
	option_number.text = dialogue_counter

func set_shortcut(new_shortcut:ShortCut):
	$option_button.shortcut = new_shortcut
