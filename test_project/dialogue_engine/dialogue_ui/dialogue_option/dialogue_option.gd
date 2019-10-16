extends Label
class_name dialogue_option

enum { UNTOUCHED, CLICKED, PASSED }

const BACK_JSON = { text = "Back.", noteworthy = false, is_back_option = true }
const CONTINUE_JSON = { text = "Continue.", noteworthy = false }
const EXIT_JSON = { text = "Exit.", noteworthy = false, exits_dialogue = true }
const CUSTOM_JSON = { }

export(String) var speaker
export(Array, String) var listeners

#warning-ignore:unused_class_variable
export(int, -10, 10) var politeness_change = 0
#warning-ignore:unused_class_variable
export(int, -10, 10) var reliability_change = 0
#warning-ignore:unused_class_variable
export(int, -10, 10) var selflessness_change = 0
#warning-ignore:unused_class_variable
export(int, -10, 10) var sincerity_change = 0

export var big_deal:bool = false

export(float, 0, 1) var required_approval_rating = 0

export(int, FLAGS, "Politeness", "Reliability", "Selflessness", "Sincerity") var values_enable_success

export(Array, Array, String, MULTILINE) var success_messages = [ [ ] ]
export var loop_successes_from = 0
#warning-ignore:unused_class_variable
export(String) var success_tree = ""

#warning-ignore:unused_class_variable
export(int, -10, 10) var approval_rating_change_on_success

export(Array, Array, String, MULTILINE) var failure_messages = [ [ ] ]
export var loop_failures_from = 0
#warning-ignore:unused_class_variable
export(String) var failure_tree = ""

export(String, MULTILINE) var tooltip = ""

#warning-ignore:unused_class_variable
export var single_use = true
export var exits_dialogue = false
#warning-ignore:unused_class_variable
export var is_back_option = false

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

var option_button
var option_number
var dialogue_option

signal option_confirmed


# Called when the node enters the scene tree for the first time.
func _ready():
	update_appearance()
	
	option_button.connect("button_up", self, "check_option")


func init(option_id:String, option_info:Dictionary = CUSTOM_JSON):
	option_button = $option_button
	option_number = $option_text/option_number
	dialogue_option = $option_text/dialogue_option
	
	option_button.connect("current_color", self, "update_appearance")
	
	id = option_id
	name = id
	# TODO: fix tooltips
	match option_id:
		CONSTANTS.BACK_OPTION:
			parse_option(BACK_JSON, true)
		CONSTANTS.CONTINUE_OPTION:
			parse_option(CONTINUE_JSON, true)
		CONSTANTS.EXIT_OPTION:
			parse_option(EXIT_JSON, true)
	
	option_json = option_info
	
	parse_option(option_json)

func parse_option(option_info, only_parse = false):
	for key in option_info.keys():
		set(key, option_info[key])
	
	if not only_parse:
		var success = success_counter >= failure_counter
		
		var opt_txt:Array = option_text.get(CONSTANTS.BUTTON_TEXT if success else CONSTANTS.BUTTON_TEXT_FAILURE, [ text ])
		var new_option_text = opt_txt[math_helper.calculate_loop_modulo(success_counter if success else failure_counter, opt_txt.size(), loop_success_option_text_from if success else loop_failure_option_text_from)]
		
		text = new_option_text
		dialogue_option.type_text(new_option_text)
		
		option_button.hint_tooltip = tooltip

func check_option():
	var new_click_status = check_success()
	
	GAME_CONSTANTS.print_to_console("\n" + ("SUCCESS!" if new_click_status >= PASSED else "FAILURE!"))
	
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
		var values = listener.calculate_perception_value(listener.character_perceptions.get(speaker, [speaker.percieved_starting_values])[NPC._PERCEPTION_VALUES])
		
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
			
			GAME_CONSTANTS.print_to_console(value_update.substr(0, value_update.length() - 2))
		else:
			GAME_CONSTANTS.print_to_console("No Perception Updates, this Dialogue Option has already been used before!")
	else:
		GAME_CONSTANTS.print_to_console("No Updates, this Dialogue Option has already been passed before!")
	
	for listener in listeners:
		listener.remember_response({ "id": id, "speaker": speaker, "listeners": listeners, "success": option_success, "value_changes": value_changes if untouched(1) else { }, "approval_change": approval_rating_change_on_success, "big_deal": big_deal, "success_counter": success_counter, "failure_counter": failure_counter, "json": option_json, "noteworthy": noteworthy })
	
	var succ_mess = math_helper.calculate_loop_modulo(success_counter - 1, success_messages.size(), loop_successes_from)
	var fail_mess = math_helper.calculate_loop_modulo(failure_counter - 1, failure_messages.size(), loop_failures_from)
			
	var success_message = success_messages[succ_mess] if not success_messages.empty() else [ ]
	var failure_message = failure_messages[fail_mess] if not failure_messages.empty() else [ ]
	
	emit_signal("option_confirmed", { "success": option_success, "message": success_message if option_success else failure_message, "new_tree": success_tree if option_success else failure_tree, "big_deal": big_deal, "is_back_option": is_back_option, "json": option_json })

func compose_value_changes():
	return { GAME_CONSTANTS._PERCEPTION_VALUES[0]: politeness_change, GAME_CONSTANTS._PERCEPTION_VALUES[1]: reliability_change, GAME_CONSTANTS._PERCEPTION_VALUES[2]: selflessness_change, GAME_CONSTANTS._PERCEPTION_VALUES[3]: sincerity_change }

func update_appearance(theme_color = null):
	var new_color = null
	
	if big_deal:
		new_color = big_deal_color
	elif not untouched():
		option_number.modulate.a = clicked_alpha
		dialogue_option.modulate.a = clicked_alpha
	
	new_color = theme_color
	
	option_number.set("custom_colors/font_color", new_color)
	dialogue_option.set("custom_colors/default_color", new_color)

func untouched(bigger_than = 0):
	return success_counter + failure_counter <= bigger_than

func update_list_number(new_number):
	dialogue_counter = "%d." % [new_number]
	text = "%s %s" % [dialogue_counter, text]
	
	option_number.text = dialogue_counter

func set_shortcut(new_shortcut:ShortCut):
	option_button.shortcut = new_shortcut
