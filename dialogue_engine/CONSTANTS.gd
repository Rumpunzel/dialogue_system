extends Node

const CHARACTERS_JSON:String = "res://data/characters"
const DIALOGUE_PATHS:String = "res://data/dialogues"
# Default dialogue tree name
const DEFAULT_TREE = "start"

# Dialogue hightlight color
const HIGHLIGHT_COLOR = "#830303"

# Dialogue option properties
const BUTTON_TEXT = "button_text"
const BUTTON_TEXT_FAILURE = "button_text_after_failure"

# Dialogue option constants
const BACK_OPTION = "_back_option"
const CONTINUE_OPTION = "_continue_option"
const EXIT_OPTION = "_exit_option"
const CUSTOM_OPTION = "custom_option"

export(String) var characters_path = ""

# Print updates to console?
var verbose_mode = false
var log_history:Dictionary = { }


func print_to_console(print_string):
	print_string = str(print_string)
	
	var current_time = OS.get_system_time_msecs()
	log_history[current_time] = print_string
	
	if verbose_mode:
		print(print_string)

func get_CHARACTERS():
	return get_node(characters_path) if has_node(characters_path) else null
