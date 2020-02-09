extends Node

# Path in the global file system to the root directory with all the characters
const CHARACTERS_JSON:String = "res://data/characters"
# Path in the global file system to the root directory with all the conversations
const DIALOGUE_PATHS:String = "res://data/dialogues"
# Local path to the dialogue_window in every scene
const DIALOGUE_WINDOW_PATH:String = "foreground/ui/dialogue_window"
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

# Print updates to console?
var verbose_mode = true
var log_history:Dictionary = { }


# Used to log game information and print it to the console
func print_to_console(print_string):
	print_string = str(print_string)
	
	var current_time = OS.get_system_time_msecs()
	log_history[current_time] = print_string
	
	if verbose_mode:
		print(print_string)
