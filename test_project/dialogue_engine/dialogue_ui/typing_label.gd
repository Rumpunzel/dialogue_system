extends RichTextLabel
class_name TypingLabel

# This is an extended RichTextLabel that supports a bunch more functionality
# Mainly being able to have it type out text, including different typing speeds and skipping
#	as well as a custom meta data format for simple coloring and selective tool tips

# Definition of all used punctuation which will cause a brief pause when typing out the message
const SENTENCE_ENDS = [ ".", "?", "!", ":" ]
const PUNCTUATIONS = [ ",", ";" ]
# Definition of the meta code to color in the text and add tool tips
# Surrounding a phrase with '<' & '>' will color it in the CONSTANTS.HIGHLIGHT_COLOR
# Surrounding a phrase with '{' & '}' will add the tool tip functionality
#	type the tool tip first into the brackets followed by '|' and then the message
#	e.g. "Don't go too <{No seriously, don't.|deep.}>"
#	this will display as "Don't go too deep." with "deep." being coloured
#	and it will display "No seriously, don't." when hovered over
const META_MARKDOWN = [ "<", "{", "|", "}", ">" ]
const META_BBCODE = [ "[color=%s]" % [CONSTANTS.HIGHLIGHT_COLOR], "[url=\"", "\"]", "[/url]", "[/color]" ]

export var typing_speed:float = 50
export var pause_on_sentence_end:float = 0.2
export var pause_on_comma:float = 0.1

onready var punctuation_timer = Timer.new()

var visible_counter:float
var currently_counting = true
var typing = true
var remove_double_spaces = true

signal finished_typing


func _ready():
	add_child(punctuation_timer)
	punctuation_timer.one_shot = false
	punctuation_timer.connect("timeout", self, "continue_counting")
	
	# How the specific tool tips work is by modifying the tool tip for the entire message while the text is being hovered
	connect("meta_hover_started", self, "modify_tooltip")
	connect("meta_hover_ended", self, "modify_tooltip", [true])

# Type out the text while briefly pausing for punctuation
func _process(delta):
	if typing:
		if typing_speed > 0:
			if text.length() > 0 and currently_counting:
				visible_counter += delta * typing_speed
				visible_counter = min(text.length(), visible_counter)
				visible_characters = int(visible_counter)
				
				var current_character = text[max(0, visible_characters - 1)]
				
				if current_character in SENTENCE_ENDS:
					currently_counting = false
					punctuation_timer.start(pause_on_sentence_end)
				elif current_character in PUNCTUATIONS:
					currently_counting = false
					punctuation_timer.start(pause_on_comma)
		else:
			visible_characters = text.length()
		
		if visible_characters == text.length():
			typing = false
			
			emit_signal("finished_typing")

# The tpying is skipped at a button input
func _input(event):
	if (event is InputEventKey or event is InputEventMouseButton) and typing:
		visible_counter = text.length()

# To use this script, simply call this method from anywhere with the text you want it to type
func type_text(new_text, clean_spaces = true):
	parse_markdown(new_text)
	visible_counter = 0
	currently_counting = true
	typing = true
	remove_double_spaces = clean_spaces

func parse_markdown(parse_text:String):
	# Replaces the meta code for coloring and tooltips with the less readable stuff that actually does anything
	for i in META_MARKDOWN.size():
		parse_text = parse_text.replace(META_MARKDOWN[i], META_BBCODE[i])
	
	var parsed_text = ""
	
	# Remove any double spaces which may have slipped through
	if remove_double_spaces:
		while not parse_text == parsed_text:
			parsed_text = parse_text
			parse_text = parse_text.replace("  ", " ")
	
	parse_bbcode(parse_text)

func continue_counting():
	currently_counting = true

func modify_tooltip(new_tooltip, erase_instead = false):
	hint_tooltip = new_tooltip if typeof(new_tooltip) == TYPE_STRING and not erase_instead else ""
