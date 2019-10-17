extends RichTextLabel
class_name TypingLabel

const SENTENCE_ENDS = [ ".", "?", "!", ":" ]
const PUNCTUATIONS = [ ",", ";" ]

const META_MARKDOWN = [ "<", "{", "|", "}", ">" ]
const META_BBCODE = [ "[color=%s]" % [CONSTANTS.HIGHLIGHT_COLOR], "[url=\"", "\"]", "[/url]", "[/color]" ]

export var typing_speed:float = 50
export var pause_on_sentence_end:float = 0.2
export var pause_on_comma:float = 0.1

onready var punctuation_timer = Timer.new()

var visible_counter:float
var currently_counting = true
var typing = true

signal finished_typing


func _ready():
	add_child(punctuation_timer)
	punctuation_timer.one_shot = false
	punctuation_timer.connect("timeout", self, "continue_counting")
	
	connect("meta_hover_started", self, "modify_tooltip")
	connect("meta_hover_ended", self, "modify_tooltip", [true])

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

func _input(event):
	if (event is InputEventKey or event is InputEventMouseButton) and typing:
		visible_counter = text.length()


func type_text(new_text):
	parse_markdown(new_text)
	visible_counter = 0
	currently_counting = true
	typing = true

func parse_markdown(parse_text:String):
	for i in META_MARKDOWN.size():
		parse_text = parse_text.replace(META_MARKDOWN[i], META_BBCODE[i])
	
	var parsed_text = ""
	
	while not parse_text == parsed_text:
		parsed_text = parse_text
		parse_text = parse_text.replace("  ", " ")
	
	parse_bbcode(parse_text)

func continue_counting():
	currently_counting = true

func modify_tooltip(new_tooltip, erase_instead = false):
	hint_tooltip = new_tooltip if typeof(new_tooltip) == TYPE_STRING and not erase_instead else ""